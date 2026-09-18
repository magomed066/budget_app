import 'package:budget_app/app/theme/app_colors.dart';
import 'package:budget_app/features/auth/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HeaderWidget extends ConsumerWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Hello, ",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),
              Text(
                getUserName(ref),
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 196, 176),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // SizedBox(height: 1),
          Row(
            children: [
              Text(
                "Ready to track your money..!",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String getUserName(WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    final String name;

    if (user.isLoading) {
      name = '...';
    } else if (user.hasError) {
      name = 'Unable to load name';
    } else {
      name = user.value?.firstName ?? 'Guest';
    }

    return name;
  }
}
