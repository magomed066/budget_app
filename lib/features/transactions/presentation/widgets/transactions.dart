import 'package:budget_app/app/theme/app_colors.dart';
import 'package:budget_app/core/utils/async_error_handler.dart';
import 'package:budget_app/core/utils/date_formatter.dart';
import 'package:budget_app/features/transactions/presentation/transactions_screen.dart';
import 'package:budget_app/features/transactions/presentation/widgets/transaction_card.dart';
import 'package:budget_app/features/transactions/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionsWidget extends ConsumerWidget {
  const TransactionsWidget({super.key});

  static const _headingStyle = TextStyle(
    color: AppColors.primaryText,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(transactionControllerProvider, (previous, next) {
      handleAsyncError(
        next,
        logMessage: 'Transactions failed to load',
        fallbackMessage: 'Could not load your transactions. Please try again.',
      );
    });

    final transactionsState = ref.watch(transactionControllerProvider);
    final transactions = transactionsState.value ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: Text('Transactions', style: _headingStyle)),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => TransactionsScreen()),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryText,
                side: const BorderSide(color: AppColors.dark),
                shape: const StadiumBorder(),
                minimumSize: const Size(0, 32),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: const Text('View all'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          spacing: 10,
          children: [
            for (final tx in transactions)
              TransactionTile(
                key: ValueKey(tx.id),
                title: tx.account.name,
                description: tx.note,
                amountMinor: tx.amountMinor,
                type: tx.type,
                date: formatMonthDay(tx.createdAt.toLocal()),
              ),
          ],
        ),
      ],
    );
  }
}
