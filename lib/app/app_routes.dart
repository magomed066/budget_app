import 'package:budget_app/features/auth/presentation/login_page.dart';
import 'package:flutter/material.dart';

abstract final class AppRoutes {
  static MaterialPageRoute<void> login() {
    return MaterialPageRoute(builder: (context) => const LoginPage());
  }
}
