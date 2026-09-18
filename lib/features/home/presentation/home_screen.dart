import 'package:budget_app/features/home/presentation/widgets/balance_card.dart';
import 'package:budget_app/features/home/presentation/widgets/header.dart';
import 'package:budget_app/features/transactions/presentation/widgets/transactions.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderWidget(),
          SizedBox(height: 10),
          BalanceCardWidget(),
          SizedBox(height: 24),
          TransactionsWidget(),
        ],
      ),
    );
  }
}
