import 'package:budget_app/app/theme/app_theme.dart';
import 'package:budget_app/features/auth/presentation/welcome_page.dart';
import 'package:budget_app/shared/widgets/toaster.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Budget App',
      theme: AppTheme.light,
      builder: Toaster.builder,
      home: const WelcomePage(),
    );
  }
}
