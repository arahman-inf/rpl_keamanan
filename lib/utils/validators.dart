/// Kumpulan fungsi validasi dan sanitasi input pengguna.
class Validators {
  /// Validasi format email baku.
  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email.trim());
  }

  /// Membersihkan input dari karakter berbahaya (mencegah XSS).
  static String sanitize(String input) {
    return input
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .trim();
  }

  /// Validasi field teks umum.
  static String? validateText(
    String? value, {
    String fieldName = 'Field',
    int minLength = 1,
    int maxLength = 100,
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    final len = value.trim().length;
    if (len < minLength || len > maxLength) {
      return '$fieldName harus antara $minLength-$maxLength karakter';
    }
    return null;
  }

  /// Validasi email.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!isValidEmail(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  /// Validasi nomor telepon (10-13 digit angka).
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    final regex = RegExp(r'^[0-9]{10,13}$');
    if (!regex.hasMatch(value.trim())) {
      return 'Nomor telepon harus berupa 10-13 digit angka';
    }
    return null;
  }

  /// Validasi URL (diawali http:// atau https://).
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'URL tidak boleh kosong';
    }
    final regex = RegExp(r'^https?:\/\/[^\s\/$.?#].[^\s]*$', caseSensitive: false);
    if (!regex.hasMatch(value.trim())) {
      return 'URL tidak valid (harus diawali http:// atau https://)';
    }
    return null;
  }

  /// Validasi password (min 8 karakter, 1 kapital, 1 angka, 1 simbol).
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    if (!regex.hasMatch(value)) {
      return 'Password minimal 8 karakter, mengandung 1 huruf kapital, 1 angka, dan 1 simbol';
    }
    return null;
  }
}