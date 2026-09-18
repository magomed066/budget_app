import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(
    colors: true,
    lineLength: 120,
    printEmojis: false,
    methodCount: 0,
    errorMethodCount: 0,
  ),
);
