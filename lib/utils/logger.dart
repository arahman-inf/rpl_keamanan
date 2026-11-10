import 'package:flutter/foundation.dart';

/// Level log, dari yang paling rendah ke paling tinggi.
enum LogLevel { debug, info, warning, error }

/// Logger terstruktur yang aman.
///
/// - Log hanya ditampilkan pada mode debug ([kDebugMode]).
/// - Nilai yang tampak sensitif (token, password, API key, dll.)
///   otomatis disamarkan menjadi `***`.
class Logger {
  Logger._();

  static final RegExp _sensitive = RegExp(
    r'(token|password|passwd|pin|api[_-]?key|authorization|secret)(\s*[:=]\s*)(\S+)',
    caseSensitive: false,
  );

  /// Mencatat pesan level debug.
  static void debug(String message) => _log(LogLevel.debug, message);

  /// Mencatat pesan level info.
  static void info(String message) => _log(LogLevel.info, message);

  /// Mencatat pesan level warning.
  static void warning(String message) => _log(LogLevel.warning, message);

  /// Mencatat pesan level error.
  static void error(String message) => _log(LogLevel.error, message);

  /// Menyamarkan nilai sensitif pada [message].
  @visibleForTesting
  static String redact(String message) {
    return message.replaceAllMapped(
      _sensitive,
      (m) => '${m[1]}${m[2]}***',
    );
  }

  static void _log(LogLevel level, String message) {
    if (!kDebugMode) return;
    debugPrint('[${level.name.toUpperCase()}] ${redact(message)}');
  }
}
