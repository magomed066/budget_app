import 'package:budget_app/services/auth/auth_service.dart';
import 'package:budget_app/services/base/api_exception.dart';
import 'package:budget_app/shared/theme/colors.dart';
import 'package:budget_app/shared/utils/logger.dart';
import 'package:budget_app/widgets/app_bar/app_bar.dart';
import 'package:budget_app/widgets/login_form/login_form.dart';
import 'package:flutter/material.dart';
import 'package:budget_app/shared/utils/toaster.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> onSubmit() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    setState(() => isLoading = true);

    try {
      final response = await authService.login(email, password);

      logger.d(response.data.toJson());
    } on ApiException catch (error) {
      logger.e('Login failed: ${error.message}');

      Toaster.error(error.userMessage);
    } catch (error) {
      logger.e('Unexpected error: $error');
      Toaster.error('Unable to sign in. Please try again.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(height: 60, title: ''),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Welcome back',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Sign in to continue managing your subscriptions',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 36),
                  LoginForm(
                    emailController: emailController,
                    passwordController: passwordController,
                    onSignIn: onSubmit,
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFFC78571),
                          disabledForegroundColor: const Color(0xFFC78571),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text('Create Account'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
