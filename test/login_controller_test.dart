import 'dart:async';
import 'dart:convert';

import 'package:budget_app/core/network/api_exception.dart';
import 'package:budget_app/core/network/api_service.dart';
import 'package:budget_app/core/network/api_service_provider.dart';
import 'package:budget_app/features/auth/presentation/login_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

http.Response loginResponse() => http.Response(
  jsonEncode({
    'success': true,
    'data': {
      'id': 1,
      'email': 'user@example.com',
      'firstName': 'Test',
      'lastName': 'User',
      'phone': null,
      'createdAt': '2026-01-01T00:00:00Z',
      'updatedAt': '2026-01-01T00:00:00Z',
      'accessToken': 'access',
      'refreshToken': 'refresh',
    },
  }),
  200,
);

ProviderContainer containerWith(
  Future<http.Response> Function(http.Request) handler,
) {
  final client = MockClient(handler);
  addTearDown(client.close);
  return ProviderContainer.test(
    overrides: [
      apiServiceProvider.overrideWithValue(
        ApiService(baseUrl: 'http://localhost:3000', client: client),
      ),
    ],
  );
}

void main() {
  test(
    'login sends credentials, blocks duplicates, and exposes the user',
    () async {
      final response = Completer<http.Response>();
      var calls = 0;
      final container = containerWith((request) {
        calls++;
        expect(request.method, 'POST');
        expect(request.url.path, '/api/auth/login');
        expect(request.headers['content-type'], 'application/json');
        expect(jsonDecode(request.body), {
          'email': 'user@example.com',
          'password': ' password ',
        });
        return response.future;
      });
      container.listen(loginControllerProvider, (_, _) {});
      expect(container.read(loginControllerProvider).value, isNull);
      final controller = container.read(loginControllerProvider.notifier);
      final pending = controller.login('user@example.com', ' password ');
      expect(container.read(loginControllerProvider).isLoading, isTrue);
      await controller.login('user@example.com', ' password ');
      response.complete(loginResponse());
      await pending;
      expect(calls, 1);
      final state = container.read(loginControllerProvider);
      expect(state.isLoading, isFalse);
      expect(state.requireValue!.email, 'user@example.com');
      expect(state.requireValue!.accessToken, 'access');
    },
  );

  test('backend errors remain available and login can be retried', () async {
    var calls = 0;
    final container = containerWith((_) async {
      if (calls++ == 0) {
        return http.Response(
          jsonEncode({
            'errors': ['Invalid email or password'],
          }),
          401,
        );
      }
      return loginResponse();
    });
    container.listen(loginControllerProvider, (_, _) {});
    final controller = container.read(loginControllerProvider.notifier);
    await controller.login('user@example.com', 'wrong');
    final error = container.read(loginControllerProvider).error as ApiException;
    expect(error.statusCode, 401);
    expect(error.userMessage, 'Invalid email or password');
    await controller.login('user@example.com', 'correct');
    expect(container.read(loginControllerProvider).hasError, isFalse);
    expect(container.read(loginControllerProvider).requireValue!.id, 1);
  });

  test(
    'finishing a request after disposal does not update disposed state',
    () async {
      final response = Completer<http.Response>();
      final container = containerWith((_) => response.future);
      final subscription = container.listen(loginControllerProvider, (_, _) {});
      final pending = container
          .read(loginControllerProvider.notifier)
          .login('user@example.com', 'password');
      subscription.close();
      await container.pump();
      expect(container.exists(loginControllerProvider), isFalse);
      response.complete(loginResponse());
      await expectLater(pending, completes);
    },
  );
}
