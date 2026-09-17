enum ApiErrorType { http, network, timeout, invalidResponse }

class ApiException implements Exception {
  const ApiException({
    required this.message,
    required this.type,
    this.statusCode,
    this.details,
  });

  final String message;
  final ApiErrorType type;
  final int? statusCode;
  final dynamic details;

  /// Backend error messages, falling back to the request error message.
  String get userMessage {
    final body = details;
    final errors = body is Map ? body['errors'] : null;

    if (errors is List) {
      final text = errors
          .whereType<String>()
          .map((error) => error.trim())
          .where((error) => error.isNotEmpty)
          .join('\n');

      if (text.isNotEmpty) return text;
    }

    return message;
  }

  @override
  String toString() {
    return 'ApiException(${statusCode ?? type.name}): $message';
  }
}
