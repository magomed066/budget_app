import 'package:budget_app/app/app_shell.dart';
import 'package:budget_app/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';

abstract final class AppRoutes {
  static MaterialPageRoute<void> home() {
    return MaterialPageRoute(builder: (context) => const AppShell());
  }

  static MaterialPageRoute<void> login() {
    return MaterialPageRoute(builder: (context) => const LoginPage());
  }
}
