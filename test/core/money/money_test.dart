import 'package:evarkadasligi/core/money/debt_simplifier.dart';
import 'package:evarkadasligi/core/money/money.dart';
import 'package:evarkadasligi/core/money/split_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Money.format', () {
    test('Turkish puts the symbol after the number', () {
      expect(Money.format(1234567, currency: 'TRY', locale: 'tr'), '12.345,67 ₺');
      expect(Money.format(25000, currency: 'TRY', locale: 'tr'), '250,00 ₺');
      expect(Money.format(5, currency: 'TRY', locale: 'tr'), '0,05 ₺');
    });

    test('English puts the symbol first', () {
      expect(Money.format(1234567, currency: 'USD', locale: 'en'), r'$12,345.67');
      expect(Money.format(100, currency: 'EUR', locale: 'en'), '€1.00');
      expect(Money.format(100, currency: 'GBP', locale: 'en'), '£1.00');
      expect(Money.format(100, currency: 'CHF', locale: 'en'), 'CHF1.00');
    });

    test('signs', () {
      expect(Money.format(-1050, currency: 'TRY', locale: 'tr'), '−10,50 ₺');
      expect(Money.format(1050, currency: 'TRY', locale: 'tr', showPlus: true), '+10,50 ₺');
      expect(Money.format(0, currency: 'TRY', locale: 'tr', showPlus: true), '0,00 ₺');
    });
  });

  test('formatHundredths', () {
    expect(Money.formatHundredths(3333, locale: 'tr'), '33,33');
    expect(Money.formatHundredths(5000, locale: 'en'), '50');
    expect(Money.formatHundredths(-5, locale: 'en'), '−0.05');
  });

  group('Money.parse', () {
    test('accepts both separators', () {
      expect(Money.parse('250'), 25000);
      expect(Money.parse('250,5'), 25050);
      expect(Money.parse('250.50'), 25050);
      expect(Money.parse('1.234,56'), 123456);
      expect(Money.parse('1,234.56'), 123456);
      expect(Money.parse('1.234'), 123400);
      expect(Money.parse('1.234.567'), 123456700);
      expect(Money.parse(' 15 000 ₺'), 1500000);
      expect(Money.parse(',5'), 50);
    });

    test('rejects invalid input', () {
      expect(Money.parse(''), isNull);
      expect(Money.parse('abc'), isNull);
      expect(Money.parse('-5'), isNull);
      expect(Money.parse('1,2345'), isNull);
      expect(Money.parse('1.2.3,456'), isNull);
      expect(Money.parse(','), isNull);
      expect(Money.parse('99999999999999'), isNull);
    });
  });

  test('toInput', () {
    expect(Money.toInput(123450, locale: 'tr'), '1234,50');
    expect(Money.toInput(123405, locale: 'en'), '1234.05');
    expect(Money.toInput(1200, locale: 'tr'), '12');
  });

  group('SplitCalculator', () {
    test('rejects invalid input', () {
      SplitError? errorOf(SplitType t, int amount, Map<String, int> input) {
        final r = SplitCalculator.compute(type: t, amountMinor: amount, input: input);
        return r is SplitFailure ? r.error : null;
      }

      expect(errorOf(SplitType.equal, 0, {'A': 1}), SplitError.invalidAmount);
      expect(errorOf(SplitType.equal, 100, {}), SplitError.noParticipants);
      expect(errorOf(SplitType.shares, 100, {'A': -1}), SplitError.negativeValue);
      expect(errorOf(SplitType.shares, 100, {'A': 0, 'B': 0}), SplitError.noParticipants);
      expect(errorOf(SplitType.percent, 100, {'A': 5000}), SplitError.percentSumMismatch);
    });

    test('percent difference is reported in basis points', () {
      final r = SplitCalculator.compute(
          type: SplitType.percent, amountMinor: 100, input: {'A': 6000, 'B': 5000});
      expect((r as SplitFailure).difference, -1000);
    });

    test('exact excess is negative', () {
      final r = SplitCalculator.compute(
          type: SplitType.exact, amountMinor: 100, input: {'A': 80, 'B': 30});
      expect((r as SplitFailure).difference, -10);
    });

    test('zero weights are left out and order is alphabetical', () {
      final r = SplitCalculator.compute(
          type: SplitType.shares, amountMinor: 100, input: {'C': 1, 'A': 1, 'B': 0});
      expect((r as SplitSuccess).shares.keys.toList(), ['A', 'C']);
    });

    test('allocate throws without positive weights', () {
      expect(() => SplitCalculator.allocate(100, {'A': 0}), throwsArgumentError);
    });

    test('SplitType.fromName', () {
      expect(SplitType.fromName('percent'), SplitType.percent);
      expect(SplitType.fromName('unknown'), SplitType.equal);
      expect(SplitType.fromName(null), SplitType.equal);
    });
  });

  group('DebtSimplifier', () {
    test('ties go to the alphabetically first uid', () {
      expect(DebtSimplifier.simplify({'B': -100, 'A': -100, 'D': 100, 'C': 100}), const [
        Transfer(fromUid: 'A', toUid: 'C', amountMinor: 100),
        Transfer(fromUid: 'B', toUid: 'D', amountMinor: 100),
      ]);
    });

    test('empty when settled', () {
      expect(DebtSimplifier.simplify({'A': 0, 'B': 0}), isEmpty);
    });

    test('Transfer value semantics', () {
      const a = Transfer(fromUid: 'A', toUid: 'B', amountMinor: 1);
      const b = Transfer(fromUid: 'A', toUid: 'B', amountMinor: 1);
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a.toString(), 'Transfer(A → B: 1)');
    });
  });
}
