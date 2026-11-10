import 'dart:async';
import 'dart:convert';
import 'dart:io' show SocketException;
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../utils/logger.dart';

/// Service untuk komunikasi HTTP dengan REST API.
///
/// Class ini menangani semua request HTTP ke API, termasuk
/// penanganan error dan timeout. Base URL dan API key diambil dari
/// [AppConfig] (file `.env`), bukan di-hardcode.
class ApiService {
  final http.Client _client;
  final String _baseUrl;

  /// Membuat [ApiService].
  ///
  /// [client] dan [baseUrl] opsional (berguna untuk pengujian);
  /// jika kosong dipakai `http.Client()` dan [AppConfig.baseUrl].
  ApiService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? AppConfig.baseUrl;

  /// Mengambil daftar pengguna dari API.
  ///
  /// Mengembalikan [List<User>] jika berhasil.
  /// Melempar [HttpException] dengan pesan yang ramah pengguna jika gagal.
  Future<List<User>> getUsers({Duration? timeout}) async {
    return _get<List<User>>(
      '/users',
      (data) => (data as List<dynamic>)
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList(),
      timeout: timeout,
    );
  }

  /// Mengambil daftar post dari API.
  ///
  /// Mengembalikan [List<Post>] jika berhasil.
  /// Melempar [HttpException] dengan pesan yang ramah pengguna jika gagal.
  Future<List<Post>> getPosts({Duration? timeout}) async {
    return _get<List<Post>>(
      '/posts',
      (data) => (data as List<dynamic>)
          .map((json) => Post.fromJson(json as Map<String, dynamic>))
          .toList(),
      timeout: timeout,
    );
  }

  /// Mengambil pengguna berdasarkan [id].
  ///
  /// Parameter [id] harus berupa integer positif.
  /// Mengembalikan [User] jika ditemukan.
  Future<User> getUserById(int id, {Duration? timeout}) async {
    return _get<User>(
      '/users/$id',
      (data) => User.fromJson(data as Map<String, dynamic>),
      timeout: timeout,
    );
  }

  /// Simulasi login untuk mendapatkan token.
  ///
  /// Password tidak pernah dicatat ke log.
  Future<String> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email.isEmpty || password.isEmpty) {
      throw HttpException('Login gagal: email dan password tidak boleh kosong');
    }
    Logger.info('Login berhasil');
    return 'dummy_token_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Menjalankan GET ke [endpoint], lalu mengubah hasil `jsonDecode`
  /// menjadi [T] lewat [parse].
  ///
  /// Semua error diterjemahkan menjadi [HttpException] berpesan aman
  /// (tanpa detail internal/stack trace); detail hanya masuk ke log debug.
  Future<T> _get<T>(
    String endpoint,
    T Function(dynamic json) parse, {
    Duration? timeout,
  }) async {
    if (_baseUrl.isEmpty) {
      throw HttpException(
        'Konfigurasi BASE_URL belum diatur. Periksa file .env Anda.',
      );
    }
    final limit = timeout ?? const Duration(seconds: AppConfig.timeoutSeconds);

    try {
      _logRequest('GET', endpoint);

      final response = await _client
          .get(Uri.parse('$_baseUrl$endpoint'), headers: _buildHeaders())
          .timeout(limit);

      _logResponse(response.statusCode);

      if (response.statusCode == 200) {
        return parse(jsonDecode(response.body));
      }
      throw HttpException(
        'Gagal memuat data. Status: ${response.statusCode}',
      );
    } on HttpException {
      rethrow;
    } on TimeoutException {
      throw HttpException(
        'Request timeout (${limit.inSeconds} detik). Periksa koneksi internet Anda.',
      );
    } on SocketException {
      throw HttpException('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on FormatException {
      throw HttpException('Format data tidak valid.');
    } on TypeError {
      throw HttpException('Format data tidak valid.');
    } catch (e) {
      Logger.error('Kesalahan tak terduga pada $endpoint: ${e.runtimeType}');
      throw HttpException('Terjadi kesalahan. Silakan coba lagi.');
    }
  }

  /// Membangun header untuk request HTTP.
  ///
  /// Menyertakan API key dari konfigurasi (tidak di-hardcode).
  Map<String, String> _buildHeaders() {
    final apiKey = AppConfig.apiKey;
    return {
      'Content-Type': 'application/json',
      if (apiKey.isNotEmpty) 'X-API-Key': apiKey,
    };
  }

  /// Logging request yang aman (tidak mencetak token/API key).
  void _logRequest(String method, String endpoint) {
    Logger.debug('[$method] $endpoint');
  }

  /// Logging response yang aman (hanya status code).
  void _logResponse(int statusCode) {
    Logger.debug('Response status: $statusCode');
  }

  /// Menutup client.
  void dispose() {
    _client.close();
  }
}

/// Exception untuk kegagalan request dengan pesan ramah pengguna.
class HttpException implements Exception {
  /// Pesan yang aman ditampilkan ke pengguna.
  final String message;

  HttpException(this.message);

  @override
  String toString() => message;
}
