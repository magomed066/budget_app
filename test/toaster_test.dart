import 'dart:convert';

import 'package:budget_app/core/network/api_exception.dart';
import 'package:budget_app/core/network/helpers.dart';
import 'package:budget_app/shared/widgets/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  tearDown(Toaster.dismiss);

  Future<void> mountToaster(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        builder: Toaster.builder,
        home: const Scaffold(body: Text('Login')),
      ),
    );
  }

  testWidgets('shows the backend 401 message and automatically dismisses it', (
    tester,
  ) async {
    await mountToaster(tester);

    try {
      ApiServiceHelpers().handleResponse(
        http.Response(
          jsonEncode({
            'success': false,
            'statusCode': 401,
            'errors': ['Invalid email or password'],
          }),
          401,
        ),
      );
      fail('Expected ApiException');
    } on ApiException catch (error) {
      Toaster.error(error.userMessage);
    }

    await tester.pump();
    expect(find.text('Invalid email or password'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pump(const Duration(seconds: 4));
    expect(find.text('Invalid email or password'), findsNothing);
  });

  testWidgets('a new toast replaces the old toast and restarts its timer', (
    tester,
  ) async {
    await mountToaster(tester);
    Toaster.error('First error');
    await tester.pump(const Duration(seconds: 3));

    Toaster.success('Saved');
    await tester.pump();
    expect(find.text('First error'), findsNothing);
    expect(find.text('Saved'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Saved'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('Saved'), findsNothing);
  });

  testWidgets('toast stays above the keyboard', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.reset);

    await mountToaster(tester);
    Toaster.error('Visible above keyboard');
    await tester.pump();

    final bounds = tester.getRect(find.text('Visible above keyboard'));
    expect(bounds.top, greaterThanOrEqualTo(0));
    expect(bounds.bottom, lessThan(700));
    await tester.pump(const Duration(seconds: 4));
    expect(tester.takeException(), isNull);
  });
}
