import 'package:budget_app/core/network/api_exception.dart';
import 'package:budget_app/core/utils/logger.dart';
import 'package:budget_app/shared/widgets/toaster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void handleAsyncError(
  AsyncValue<dynamic> next, {
  required String logMessage,
  required String fallbackMessage,
}) {
  if (!next.hasError) return;

  final error = next.error;

  logger.e(logMessage, error: error, stackTrace: next.stackTrace);

  Toaster.error(error is ApiException ? error.userMessage : fallbackMessage);
}
