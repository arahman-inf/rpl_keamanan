import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Konfigurasi aplikasi yang dimuat dari file `.env`.
///
/// Class ini menyediakan akses terpusat ke konfigurasi seperti
/// base URL dan API key, sehingga tidak ada hardcoded credential
/// di dalam kode sumber.
class AppConfig {
  AppConfig._();

  /// Base URL untuk API.
  ///
  /// Diambil dari environment variable `BASE_URL`.
  static String get baseUrl => _read('BASE_URL');

  /// API key untuk autentikasi.
  ///
  /// Diambil dari environment variable `API_KEY`.
  static String get apiKey => _read('API_KEY');

  /// Timeout untuk request HTTP (dalam detik).
  static const int timeoutSeconds = 10;

  /// Memeriksa apakah konfigurasi sudah lengkap.
  static bool isConfigured() {
    return baseUrl.isNotEmpty && apiKey.isNotEmpty;
  }

  /// Membaca nilai [key] dari `.env`; string kosong jika belum dimuat/tidak ada.
  static String _read(String key) {
    if (!dotenv.isInitialized) return '';
    return dotenv.env[key] ?? '';
  }
}
