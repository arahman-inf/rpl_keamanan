import 'package:flutter_test/flutter_test.dart';
import 'package:rpl_keamanan/utils/validators.dart';

void main() {
  group('Pengujian Validators', () {
    test('isValidEmail mengembalikan true untuk email valid', () {
      expect(Validators.isValidEmail('user@example.com'), isTrue);
    });

    test('isValidEmail mengembalikan false untuk email invalid', () {
      expect(Validators.isValidEmail('invalid-email'), isFalse);
    });

    test('sanitize membersihkan karakter bahaya HTML (XSS)', () {
      final raw = '<script>alert("hack")</script>';
      expect(Validators.sanitize(raw), '&lt;script&gt;alert(&quot;hack&quot;)&lt;/script&gt;');
    });

    test('validatePhone memvalidasi format angka 10-13 digit', () {
      expect(Validators.validatePhone('081234567890'), isNull);
      expect(Validators.validatePhone('12345'), contains('harus berupa 10-13 digit'));
    });

    test('validatePassword memvalidasi aturan keandalan kata sandi', () {
      expect(Validators.validatePassword('P@ssword123'), isNull);
      expect(Validators.validatePassword('12345'), contains('minimal 8 karakter'));
    });
  });
}