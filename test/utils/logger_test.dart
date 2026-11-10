import 'package:flutter_test/flutter_test.dart';
import 'package:secure_http/utils/logger.dart';

void main() {
  group('Logger.redact', () {
    test('menyamarkan nilai sensitif', () {
      expect(Logger.redact('token=abc123'), 'token=***');
      expect(Logger.redact('password: rahasia'), 'password: ***');
      expect(Logger.redact('X-API-Key: k3y'), contains('***'));
      expect(Logger.redact('X-API-Key: k3y'), isNot(contains('k3y')));
    });

    test('tidak mengubah pesan biasa', () {
      expect(Logger.redact('Response status: 200'), 'Response status: 200');
    });
  });
}
