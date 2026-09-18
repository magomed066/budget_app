import 'dart:convert';

import 'package:budget_app/features/accounts/data/account.dart';
import 'package:budget_app/features/auth/data/auth_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('missing account name identifies the model and field', () {
    expect(
      () => Account.fromJson({'id': 1}),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          contains('Account.name'),
        ),
      ),
    );
  });

  test(
    'missing stored token identifies the auth field without exposing data',
    () {
      expect(
        () => AuthUser.fromJson({
          'id': 1,
          'email': 'user@example.com',
          'firstName': 'Test',
          'lastName': 'User',
          'createdAt': '2026-09-16T21:40:00.257Z',
          'updatedAt': '2026-09-16T21:42:40.815Z',
        }),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message,
            'message',
            contains('AuthUser.accessToken'),
          ),
        ),
      );
    },
  );

  test('parses account payload without user fields', () {
    final payload = {
      'id': 1,
      'name': 'Cash',
      'type': 'cash',
      'currency': 'RUB',
      'openingBalanceMinor': 30000,
      'createdAt': '2026-09-16T21:40:00.257Z',
      'updatedAt': '2026-09-16T21:42:40.815Z',
    };

    final account = Account.fromJson(payload);

    expect(account.id, 1);
    expect(account.name, 'Cash');
    expect(account.type, AccountType.cash);
    expect(account.currency, Currency.RUB);
    expect(account.openingBalanceMinor, 30000);
    expect(account.createdAt, DateTime.utc(2026, 9, 16, 21, 40, 0, 257));
    expect(account.updatedAt, DateTime.utc(2026, 9, 16, 21, 42, 40, 815));
    expect(jsonDecode(jsonEncode(account.toJSON())), payload);
  });
}
