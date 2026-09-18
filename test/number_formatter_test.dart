import 'package:budget_app/core/utils/number_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('groups whole numbers with commas', () {
    expect(formatAmount(1000000), '1,000,000');
    expect(formatAmount(-1000), '-1,000');
  });

  test('formats amounts with two decimals without converting units', () {
    expect(formatAmount(30000), '30,000.00');
    expect(formatAmount(100000001), '100,000,001.00');
    expect(formatAmount(0), '0.00');
    expect(formatAmount(5), '5.00');
    expect(formatAmount(-5), '-5.00');
  });
}
