import 'package:budget_app/shared/components/button_indicator.dart';
import 'package:budget_app/shared/components/text_field.dart';
import 'package:budget_app/shared/theme/colors.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onSignIn,
    this.isLoading = false,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback? onSignIn;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(24),
      ),
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: emailController,
              label: 'Email Address',
              hintText: 'name@example.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: [AutofillHints.username],
              autocorrect: false,
            ),
            const SizedBox(height: 22),
            AppTextField(
              controller: passwordController,
              label: 'Password',
              hintText: 'Enter your password',
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
            ),
            const SizedBox(height: 22),
            SizedBox(
              height: 50,
              child: FilledButton(
                onPressed: isLoading ? () {} : onSignIn,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.backgroundBlack,
                  disabledBackgroundColor: AppColors.border,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isLoading
                    ? ButtonIndicator()
                    : const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
