import 'package:intl/intl.dart';

enum PriceFormat {
  commaDecimals, // 1,000.00
  spaceDecimals, // 10 000.00
  spaceInteger, // 10 000
  commaInteger, // 1,000
}

final _commaDecimals = NumberFormat('#,##0.00', 'en_US');
final _commaInteger = NumberFormat('#,##0', 'en_US');

String formatAmount(
  num value, {
  PriceFormat format = PriceFormat.commaDecimals,
}) {
  switch (format) {
    case PriceFormat.commaDecimals:
      return _commaDecimals.format(value);

    case PriceFormat.spaceDecimals:
      return _commaDecimals.format(value).replaceAll(',', ' ');

    case PriceFormat.spaceInteger:
      return _commaInteger.format(value).replaceAll(',', ' ');

    case PriceFormat.commaInteger:
      return _commaInteger.format(value);
  }
}
