import 'dart:async';
import 'dart:convert';

import 'package:budget_app/app/app_shell.dart';
import 'package:budget_app/core/network/api_service.dart';
import 'package:budget_app/core/network/api_service_provider.dart';
import 'package:budget_app/features/auth/presentation/screens/login_screen.dart';
import 'package:budget_app/features/auth/presentation/screens/welcome_screen.dart';
import 'package:budget_app/shared/widgets/button_indicator.dart';
import 'package:budget_app/shared/widgets/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'helpers/fake_connectivity.dart';

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
          connectivityProvider.overrideWithValue(FakeConnectivity()),
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

  testWidgets('successful login opens home and clears the auth routes', (
    tester,
  ) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    final client = MockClient(
      (_) async => http.Response(
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
      ),
    );
    addTearDown(client.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          connectivityProvider.overrideWithValue(FakeConnectivity()),
          apiServiceProvider.overrideWithValue(
            ApiService(baseUrl: 'http://localhost:3000', client: client),
          ),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          builder: Toaster.builder,
          home: const WelcomePage(),
        ),
      ),
    );
    await tester.tap(find.text('Get started'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.enterText(find.byType(TextField).first, 'user@example.com');
    await tester.enterText(find.byType(TextField).last, 'password');
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    expect(find.byType(AppShell), findsOneWidget);
    expect(find.text(r'$500'), findsOneWidget);
    expect(find.byType(LoginPage), findsNothing);
    expect(find.byType(WelcomePage), findsNothing);
    expect(navigatorKey.currentState!.canPop(), isFalse);
    expect(await navigatorKey.currentState!.maybePop(), isFalse);
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
