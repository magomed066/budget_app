import 'package:budget_app/app/app_routes.dart';
import 'package:budget_app/app/theme/auth_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/lotties/welcome.json'),
              SizedBox(height: 20),
              Text(
                'Welcome to Budjetify',
                style: TextStyle(
                  fontSize: 28,
                  color: AuthColors.primaryText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Track, analize and cancel with ease",
                style: TextStyle(fontSize: 14, color: AuthColors.secondaryText),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: () => navigateToLogin(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: AuthColors.backgroundBlack,
                  ),
                  child: Text(
                    "Get started",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToLogin(BuildContext context) {
    Navigator.of(context).push(AppRoutes.login());
  }
}
