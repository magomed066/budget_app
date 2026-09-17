import "dart:async";

import 'package:budget_app/core/network/api_exception.dart';
import 'package:budget_app/core/network/helpers.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl;
  final Duration _timeout;

  late final http.Client _client;
  late final bool _ownsClient;

  ApiService({
    required this._baseUrl,
    this._timeout = const Duration(seconds: 30),
    http.Client? client,
  }) {
    if (client == null) {
      _client = http.Client();
      _ownsClient = true;
    } else {
      _client = client;
      _ownsClient = false;
    }
  }

  Future<dynamic> _request(Future<http.Response> Function() send) async {
    try {
      final response = await send().timeout(_timeout);
      return apiServiceHelpers.handleResponse(response);
    } on TimeoutException {
      throw ApiException(
        message: 'The request timed out',
        type: ApiErrorType.timeout,
      );
    } on http.ClientException catch (err) {
      throw ApiException(message: err.message, type: ApiErrorType.network);
    }
  }

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse("$_baseUrl$endpoint");

    return _request(
      () => _client.get(url, headers: apiServiceHelpers.getHeaders(headers)),
    );
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) {
    final url = Uri.parse("$_baseUrl$endpoint");

    return _request(
      () => _client.post(
        url,
        headers: apiServiceHelpers.getHeaders(headers),
        body: apiServiceHelpers.encodeBody(body),
      ),
    );
  }

  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) {
    final url = Uri.parse("$_baseUrl$endpoint");

    return _request(
      () => _client.delete(
        url,
        headers: apiServiceHelpers.getHeaders(headers),
        body: apiServiceHelpers.encodeBody(body),
      ),
    );
  }

  Future<dynamic> patch(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) {
    final url = Uri.parse("$_baseUrl$endpoint");

    return _request(
      () => _client.patch(
        url,
        headers: apiServiceHelpers.getHeaders(headers),
        body: apiServiceHelpers.encodeBody(body),
      ),
    );
  }

  Future<dynamic> put(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) {
    final url = Uri.parse("$_baseUrl$endpoint");

    return _request(
      () => _client.put(
        url,
        headers: apiServiceHelpers.getHeaders(headers),
        body: apiServiceHelpers.encodeBody(body),
      ),
    );
  }

  void close() {
    if (_ownsClient) {
      _client.close();
    }
  }
}
