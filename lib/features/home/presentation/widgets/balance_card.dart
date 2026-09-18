import 'package:budget_app/app/theme/app_colors.dart';
import 'package:budget_app/core/network/api_exception.dart';
import 'package:budget_app/core/utils/date_formatter.dart';
import 'package:budget_app/core/utils/logger.dart';
import 'package:budget_app/core/utils/number_formatter.dart';
import 'package:budget_app/features/accounts/providers/account_provider.dart';
import 'package:budget_app/shared/widgets/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BalanceCardWidget extends ConsumerWidget {
  const BalanceCardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(accountByIdProvider(1), (previous, next) {
      if (!next.hasError || next.isLoading) return;
      if (previous?.hasError == true &&
          previous?.isLoading == false &&
          identical(previous?.error, next.error)) {
        return;
      }

      final error = next.error;
      logger.e(
        'Account failed to load',
        error: error,
        stackTrace: next.stackTrace,
      );
      Toaster.error(
        error is ApiException
            ? error.userMessage
            : 'Could not load your account. Please try again.',
      );
    });

    final account = ref.watch(accountByIdProvider(1));

    final isLoading = account.isLoading && !account.hasValue;
    final name = account.value?.name ?? "";
    final createdAt = account.value?.createdAt;
    final date = createdAt == null ? '' : formatMonthDay(createdAt.toLocal());
    final balance = formatMinorAmount(account.value?.openingBalanceMinor ?? 0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: const BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
      ),
      child: Skeletonizer(
        enabled: isLoading,
        enableSwitchAnimation: true,
        effect: ShimmerEffect(
          baseColor: Color.lerp(
            AppColors.backgroundSecondary,
            AppColors.background,
            0.3,
          )!,
          highlightColor: Color.lerp(
            AppColors.backgroundSecondary,
            AppColors.background,
            0.65,
          )!,
          duration: const Duration(milliseconds: 1200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Balance",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 46),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: Text(
                    '₽ ${balance.toString()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  date,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
