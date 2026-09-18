import 'dart:convert';

import 'package:budget_app/core/network/api_exception.dart';
import 'package:http/http.dart' as http;

class ApiServiceHelpers {
  String? encodeBody(dynamic body) {
    return body == null ? null : json.encode(body);
  }

  Map<String, String> getHeaders(Map<String, String>? headers) {
    return {
      'content-type': 'application/json',
      'accept': 'application/json',
      ...?headers,
    };
  }

  dynamic handleResponse(http.Response response) {
    final status = response.statusCode;
    final text = response.body.trim();

    if (status < 200 || status >= 300) {
      dynamic details;

      if (text.isNotEmpty) {
        try {
          details = json.decode(text);
        } on FormatException {
          details = text;
        }
      }

      throw ApiException(
        message: response.reasonPhrase ?? 'HTTP request failed.',
        type: ApiErrorType.http,
        statusCode: status,
        details: details,
      );
    }

    if (text.isEmpty) return null;

    try {
      return json.decode(text);
    } on FormatException {
      throw ApiException(
        message: 'The server returned invalid JSON.',
        type: ApiErrorType.invalidResponse,
        statusCode: status,
      );
    }
  }
}

var apiServiceHelpers = ApiServiceHelpers();
