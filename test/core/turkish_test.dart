import 'package:evarkadasligi/core/utils/turkish.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('dative follows vowel harmony', () {
    expect(Turkish.dative('Ayşe'), "Ayşe'ye");
    expect(Turkish.dative('Burak'), "Burak'a");
    expect(Turkish.dative('Cem'), "Cem'e");
    expect(Turkish.dative('Ali'), "Ali'ye");
    expect(Turkish.dative('Duygu'), "Duygu'ya");
    expect(Turkish.dative('Gül'), "Gül'e");
    expect(Turkish.dative('Ömer '), "Ömer'e");
    expect(Turkish.dative('Mark'), "Mark'a");
    expect(Turkish.dative('JJ'), "JJ'e");
    expect(Turkish.dative(''), '');
  });
}
