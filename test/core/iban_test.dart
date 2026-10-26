import 'package:evarkadasligi/core/utils/iban.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('valid IBANs', () {
    expect(Iban.isValid('TR33 0006 1005 1978 6457 8413 26'), isTrue);
    expect(Iban.isValid('tr330006100519786457841326'), isTrue);
    expect(Iban.isValid('DE89 3704 0044 0532 0130 00'), isTrue);
    expect(Iban.isValid('GB82 WEST 1234 5698 7654 32'), isTrue);
  });

  test('invalid IBANs', () {
    expect(Iban.isValid('TR33 0006 1005 1978 6457 8413 27'), isFalse);
    expect(Iban.isValid('TR33 0006 1005 1978 6457 8413'), isFalse);
    expect(Iban.isValid('1234'), isFalse);
    expect(Iban.isValid(''), isFalse);
  });

  test('format groups by four', () {
    expect(Iban.format('tr330006100519786457841326'), 'TR33 0006 1005 1978 6457 8413 26');
  });
}
