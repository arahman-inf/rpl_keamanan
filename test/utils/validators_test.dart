import 'package:flutter_test/flutter_test.dart';
import 'package:secure_http/utils/validators.dart';

void main() {
  group('Validators.isValidEmail', () {
    test('menerima email valid', () {
      expect(Validators.isValidEmail('user@example.com'), isTrue);
      expect(Validators.isValidEmail('a.b@mail.co.id'), isTrue);
    });

    test('menolak email tidak valid', () {
      expect(Validators.isValidEmail(''), isFalse);
      expect(Validators.isValidEmail('userexample.com'), isFalse);
      expect(Validators.isValidEmail('user@'), isFalse);
      expect(Validators.isValidEmail('@example.com'), isFalse);
      expect(Validators.isValidEmail('user@example'), isFalse);
      expect(Validators.isValidEmail('us er@example.com'), isFalse);
      expect(Validators.isValidEmail('a@@b.com'), isFalse);
    });
  });

  group('Validators.sanitize', () {
    test('mengganti karakter berbahaya dengan HTML entities', () {
      expect(
        Validators.sanitize('<script>alert("x")</script>'),
        '&lt;script&gt;alert(&quot;x&quot;)&lt;/script&gt;',
      );
      expect(Validators.sanitize("O'Brien"), 'O&#x27;Brien');
    });

    test('tidak mengubah input aman dan melakukan trim', () {
      expect(Validators.sanitize('  halo dunia  '), 'halo dunia');
    });

    test('hasil tidak lagi mengandung karakter berbahaya', () {
      final result = Validators.sanitize('<img src="x" onerror=\'y\'>');
      expect(result.contains('<'), isFalse);
      expect(result.contains('>'), isFalse);
      expect(result.contains('"'), isFalse);
      expect(result.contains("'"), isFalse);
    });
  });

  group('Validators.validateText', () {
    test('menolak null dan string kosong/spasi', () {
      expect(Validators.validateText(null, fieldName: 'Nama'),
          'Nama tidak boleh kosong');
      expect(Validators.validateText('', fieldName: 'Nama'),
          'Nama tidak boleh kosong');
      expect(Validators.validateText('   ', fieldName: 'Nama'),
          'Nama tidak boleh kosong');
    });

    test('menerima panjang 1 sampai 100 karakter', () {
      expect(Validators.validateText('a'), isNull);
      expect(Validators.validateText('a' * 100), isNull);
    });

    test('menolak lebih dari 100 karakter', () {
      expect(Validators.validateText('a' * 101, fieldName: 'Nama'),
          'Nama harus antara 1-100 karakter');
    });

    test('menghormati minLength dan maxLength kustom', () {
      expect(Validators.validateText('ab', minLength: 3, maxLength: 5),
          isNotNull);
      expect(Validators.validateText('abc', minLength: 3, maxLength: 5),
          isNull);
      expect(Validators.validateText('abcdef', minLength: 3, maxLength: 5),
          isNotNull);
    });
  });

  group('Validators.validatePhone', () {
    test('menerima 10-13 digit angka', () {
      expect(Validators.validatePhone('0812345678'), isNull);
      expect(Validators.validatePhone('0812345678901'), isNull);
    });

    test('menolak selain itu', () {
      expect(Validators.validatePhone(null), isNotNull);
      expect(Validators.validatePhone('081234567'), isNotNull);
      expect(Validators.validatePhone('08123456789012'), isNotNull);
      expect(Validators.validatePhone('0812-3456-78'), isNotNull);
      expect(Validators.validatePhone('08123abc45'), isNotNull);
    });
  });

  group('Validators.validateUrl', () {
    test('menerima http:// dan https://', () {
      expect(Validators.validateUrl('https://example.com'), isNull);
      expect(Validators.validateUrl('http://example.com/path?q=1'), isNull);
    });

    test('menolak skema lain atau format salah', () {
      expect(Validators.validateUrl(null), isNotNull);
      expect(Validators.validateUrl('example.com'), isNotNull);
      expect(Validators.validateUrl('ftp://example.com'), isNotNull);
      expect(Validators.validateUrl('javascript:alert(1)'), isNotNull);
      expect(Validators.validateUrl('https://'), isNotNull);
    });
  });

  group('Validators.validatePassword', () {
    test('menerima password kuat', () {
      expect(Validators.validatePassword('Abcdef1!'), isNull);
    });

    test('menolak password lemah', () {
      expect(Validators.validatePassword(null), isNotNull);
      expect(Validators.validatePassword('Ab1!'), isNotNull); // terlalu pendek
      expect(Validators.validatePassword('abcdefg1!'), isNotNull); // tanpa kapital
      expect(Validators.validatePassword('Abcdefgh!'), isNotNull); // tanpa angka
      expect(Validators.validatePassword('Abcdefg1'), isNotNull); // tanpa simbol
    });
  });
}
