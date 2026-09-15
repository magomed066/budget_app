import 'package:budget_app/widgets/home/balance.dart';
import 'package:budget_app/widgets/home/header.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 0,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10),
          child: HeaderWidget(),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 241, 241, 241),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: const BalanceWidget(),
          ),
        ),
      ],
    );
  }
}
