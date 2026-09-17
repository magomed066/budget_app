import 'package:budget_app/screens/login/login.dart';
import 'package:budget_app/shared/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Track, analize and cancel with ease",
                style: TextStyle(fontSize: 14, color: AppColors.secondaryText),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: () => navigateToLogin(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.backgroundBlack,
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LoginPage();
        },
      ),
    );
  }
}
