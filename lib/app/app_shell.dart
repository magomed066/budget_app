import 'package:budget_app/features/home/presentation/home_screen.dart';
import 'package:budget_app/features/subscriptions/presentation/subscriptions_screen.dart';
import 'package:budget_app/app/theme/app_colors.dart';
import 'package:budget_app/app/widgets/app_navigation_bar.dart';
import 'package:flutter/material.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _currentPageIndex,
          children: const [
            HomeScreen(),
            _ComingSoonPage(
              title: 'Budget',
              icon: Icons.pie_chart_outline_rounded,
            ),
            SubscriptionsScreen(),
            _ComingSoonPage(title: 'Savings', icon: Icons.savings_outlined),
            _ComingSoonPage(
              title: 'Profile',
              icon: Icons.person_outline_rounded,
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppNavigationBar(
        currentIndex: _currentPageIndex,
        onDestinationSelected: (value) {
          setState(() {
            _currentPageIndex = value;
          });
        },
      ),
    );
  }
}

class _ComingSoonPage extends StatelessWidget {
  const _ComingSoonPage({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 44, color: AppColors.primary),
          SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}
