import 'package:intl/intl.dart';

final _monthDayFormatter = DateFormat('dd/MM', 'en_US');

/// Formats the supplied date as month.day, for example 03.18.
String formatMonthDay(DateTime date) => _monthDayFormatter.format(date);
