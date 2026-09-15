import 'package:budget_app/main.dart';
import 'package:budget_app/widgets/transactions/transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app shows the transaction list', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Transactions'), findsOneWidget);
    expect(find.text('Freelance'), findsOneWidget);
    expect(find.text('Payment from Adril Shik'), findsOneWidget);
    expect(find.text(r'+$85.99'), findsOneWidget);
  });

  testWidgets('transaction card formats an expense', (tester) async {
    const expense = TransactionData(
      category: 'Food',
      description: 'Lunch',
      amount: -12.5,
      timeAgo: 'Today',
      icon: Icons.restaurant_outlined,
      accentColor: Colors.orange,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: TransactionCard(transaction: expense)),
      ),
    );

    expect(find.text(r'-$12.50'), findsOneWidget);
    expect(find.text('Lunch'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
  });
}
