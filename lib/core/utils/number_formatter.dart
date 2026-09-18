import 'package:intl/intl.dart';

final _wholeNumberFormatter = NumberFormat('#,##0', 'en_US');
final _amountFormatter = NumberFormat('#,##0.00', 'en_US');

/// Formats a whole number with comma separators, for example 1,000,000.
String formatNumber(int value) => _wholeNumberFormatter.format(value);

/// Formats the supplied value with two decimals, without converting units.
String formatMinorAmount(int value) => _amountFormatter.format(value);
