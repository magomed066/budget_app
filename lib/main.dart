import 'package:budget_app/screens/welcome/welcome.dart';
import 'package:flutter/material.dart';

import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Budget App",
      theme: AppTheme.light,
      home: WelcomePage(),
    );
  }
}
