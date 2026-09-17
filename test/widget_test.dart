import 'dart:async';
import 'dart:convert';

import 'package:budget_app/app/app_shell.dart';
import 'package:budget_app/core/network/api_service.dart';
import 'package:budget_app/core/network/api_service_provider.dart';
import 'package:budget_app/features/auth/presentation/login_page.dart';
import 'package:budget_app/features/auth/presentation/welcome_page.dart';
import 'package:budget_app/shared/widgets/button_indicator.dart';
import 'package:budget_app/shared/widgets/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  tearDown(Toaster.dismiss);

  testWidgets('welcome opens login and back returns to welcome', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(400, 850);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: WelcomePage())),
    );
    await tester.tap(find.text('Get started'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(LoginPage), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Get started'), findsOneWidget);
    expect(find.byType(LoginPage), findsNothing);
  });

  testWidgets('login shows loading then the backend error', (tester) async {
    final response = Completer<http.Response>();
    final client = MockClient((request) {
      expect(jsonDecode(request.body), {
        'email': 'user@example.com',
        'password': ' password ',
      });
      return response.future;
    });
    addTearDown(client.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiServiceProvider.overrideWithValue(
            ApiService(baseUrl: 'http://localhost:3000', client: client),
          ),
        ],
        child: MaterialApp(builder: Toaster.builder, home: const LoginPage()),
      ),
    );
    await tester.enterText(find.byType(TextField).first, ' user@example.com ');
    await tester.enterText(find.byType(TextField).last, ' password ');
    await tester.tap(find.text('Sign In'));
    await tester.pump();
    expect(find.byType(ButtonIndicator), findsOneWidget);
    response.complete(
      http.Response(
        jsonEncode({
          'errors': ['Invalid email or password'],
        }),
        401,
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(find.byType(ButtonIndicator), findsNothing);
    expect(find.text('Invalid email or password'), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
    expect(find.byType(LoginPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shell retains balance visibility when switching tabs', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AppShell()));
    expect(find.text(r'$500'), findsOneWidget);
    await tester.tap(find.text('Hide'));
    await tester.pump();
    expect(find.text('••••••'), findsOneWidget);
    await tester.tap(find.text('Budget').last);
    await tester.pumpAndSettle();
    expect(find.text(r'$500'), findsNothing);
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('••••••'), findsOneWidget);
    await tester.tap(find.text('Show'));
    await tester.pump();
    expect(find.text(r'$500'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
