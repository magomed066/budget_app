import 'package:budget_app/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:budget_app/core/utils/number_formatter.dart';
import 'package:budget_app/features/transactions/data/transaction.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.title,
    required this.description,
    required this.amountMinor,
    required this.type,
    required this.date,
    this.borderRadius = 16,
  });

  final String title;
  final String description;
  final int amountMinor;
  final TransactionType type;
  final String date;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final isIncome = type == TransactionType.income;

    final backgroundColor = isIncome ? AppColors.success : AppColors.error;
    final iconBackgroundColor = isIncome
        ? AppColors.successIconBackground
        : AppColors.errorIconBackground;
    final iconColor = isIncome ? AppColors.successIcon : AppColors.errorIcon;
    final titleColor = isIncome ? AppColors.cardTitle : AppColors.card;
    final subtitleColor = isIncome ? AppColors.successText : AppColors.card;
    final icon = isIncome ? Icons.south_west_rounded : Icons.north_east_rounded;
    final amount =
        '${type == TransactionType.income ? '+' : '-'} '
        '${formatAmount(amountMinor, format: PriceFormat.commaInteger)}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: AppColors.border, width: 0.8),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.white, size: 20),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Title + description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Amount + frequency
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                amount,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              // const SizedBox(height: 2),
              // Text(
              //   date,
              //   style: TextStyle(
              //     color: subtitleColor,
              //     fontSize: 13,
              //     fontWeight: FontWeight.w400,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
