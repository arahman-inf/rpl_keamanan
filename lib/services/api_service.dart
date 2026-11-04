import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/user.dart';
import '../models/post.dart';
import '../utils/logger.dart';

/// Service untuk menangani komunikasi HTTP REST API secara aman.
class ApiService {
  final http.Client _client;
  final String _baseUrl;

  ApiService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? AppConfig.baseUrl;

  Map<String, String> _buildHeaders() {
    return {
      'Content-Type': 'application/json',
      'X-API-Key': AppConfig.apiKey,
    };
  }

  Future<List<User>> getUsers() async {
    try {
      Logger.info('[GET] /users');
      final response = await _client
          .get(
            Uri.parse('$_baseUrl/users'),
            headers: _buildHeaders(),
          )
          .timeout(Duration(seconds: AppConfig.timeoutSeconds));

      Logger.info('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data pengguna. Status: ${response.statusCode}');
      }
    } on TimeoutException {
      Logger.error('Request timeout');
      throw Exception('Request timeout. Periksa koneksi internet Anda.');
    } on SocketException {
      Logger.error('No internet connection');
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } catch (e, stackTrace) {
      Logger.error('Kesalahan server', e, stackTrace);
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<User> getUserById(int id) async {
    try {
      Logger.info('[GET] /users/$id');
      final response = await _client
          .get(
            Uri.parse('$_baseUrl/users/$id'),
            headers: _buildHeaders(),
          )
          .timeout(Duration(seconds: AppConfig.timeoutSeconds));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception('Gagal memuat data pengguna. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<List<Post>> getPosts() async {
    try {
      Logger.info('[GET] /posts');
      final response = await _client
          .get(
            Uri.parse('$_baseUrl/posts'),
            headers: _buildHeaders(),
          )
          .timeout(Duration(seconds: AppConfig.timeoutSeconds));

      Logger.info('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data postingan. Status: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Request timeout. Periksa koneksi internet Anda.');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}