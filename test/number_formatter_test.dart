import 'package:budget_app/core/utils/number_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('groups whole numbers with commas', () {
    expect(formatNumber(1000000), '1,000,000');
    expect(formatNumber(-1000), '-1,000');
  });

  test('formats amounts with two decimals without converting units', () {
    expect(formatMinorAmount(30000), '30,000.00');
    expect(formatMinorAmount(100000001), '100,000,001.00');
    expect(formatMinorAmount(0), '0.00');
    expect(formatMinorAmount(5), '5.00');
    expect(formatMinorAmount(-5), '-5.00');
  });
}
