import 'package:budget_app/app/app_routes.dart';
import 'package:budget_app/app/theme/auth_colors.dart';
import 'package:budget_app/core/network/api_exception.dart';
import 'package:budget_app/features/auth/presentation/widgets/login_form.dart';
import 'package:budget_app/features/auth/providers/login_provider.dart';
import 'package:budget_app/shared/widgets/app_bar.dart';
import 'package:budget_app/shared/widgets/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void onSubmit() {
    final email = emailController.text.trim();
    if (email.isEmpty || passwordController.text.isEmpty) {
      Toaster.warning("Input email and password");
      return;
    }

    ref
        .read(loginControllerProvider.notifier)
        .login(email, passwordController.text);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);

    ref.listen(loginControllerProvider, (previous, next) {
      if (next.hasError) {
        final error = next.error;
        Toaster.error(
          error is ApiException
              ? error.userMessage
              : 'Login failed. Please try again.',
        );
        return;
      }

      if (!next.isLoading && next.value != null) {
        Navigator.of(context)
            .pushAndRemoveUntil(AppRoutes.home(), (route) => false);
      }
    });

    return Scaffold(
      backgroundColor: AuthColors.background,
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
                      color: AuthColors.primaryText,
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
                      color: AuthColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 36),
                  LoginForm(
                    emailController: emailController,
                    passwordController: passwordController,
                    onSignIn: onSubmit,
                    isLoading: loginState.isLoading,
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
                          color: AuthColors.secondaryText,
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
