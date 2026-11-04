import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Konfigurasi aplikasi terpusat yang diambil dari file .env.
class AppConfig {
  /// Base URL API dari environment variable.
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';

  /// API key autentikasi dari environment variable.
  static String get apiKey => dotenv.env['API_KEY'] ?? '';

  /// Durasi batas waktu HTTP request dalam detik.
  static const int timeoutSeconds = 10;

  /// Memeriksa kelengkapan konfigurasi .env.
  static bool isConfigured() {
    return baseUrl.isNotEmpty && apiKey.isNotEmpty;
  }
}