import 'package:evarkadasligi/features/pro/domain/savings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('savingsPercent', () {
    test('29,99 aylık, 199,99 yıllık: yüzde 44', () {
      expect(savingsPercent(monthlyMinor: 2999, annualMinor: 19999), 44);
    });

    test('79,99 aylık, 549,99 yıllık: yüzde 42', () {
      expect(savingsPercent(monthlyMinor: 7999, annualMinor: 54999), 42);
    });

    test('yıllık = 12 ay ise 0', () {
      expect(savingsPercent(monthlyMinor: 1000, annualMinor: 12000), 0);
    });

    test('yıllık daha pahalıysa negatif değil 0', () {
      expect(savingsPercent(monthlyMinor: 1000, annualMinor: 13000), 0);
    });
  });
}
