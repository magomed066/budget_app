import 'package:budget_app/app/theme/app_colors.dart';
import 'package:budget_app/core/network/api_exception.dart';
import 'package:budget_app/core/utils/date_formatter.dart';
import 'package:budget_app/core/utils/logger.dart';
import 'package:budget_app/core/utils/number_formatter.dart';
import 'package:budget_app/features/transactions/data/transaction.dart';
import 'package:budget_app/features/transactions/presentation/widgets/transaction_card.dart';
import 'package:budget_app/features/transactions/providers/transaction_provider.dart';
import 'package:budget_app/shared/widgets/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionsWidget extends ConsumerWidget {
  const TransactionsWidget({super.key});

  static const _headingStyle = TextStyle(
    color: AppColors.primaryText,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  void _showAllTransactions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.background,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text('All transactions', style: _headingStyle),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const _EmptyTransactions(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(transactionControllerProvider, (previous, next) {
      if (!next.hasError) return;
      final error = next.error;
      logger.e(
        'Transactions failed to load',
        error: error,
        stackTrace: next.stackTrace,
      );
      Toaster.error(
        error is ApiException
            ? error.userMessage
            : 'Could not load your transactions. Please try again.',
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
              onPressed: () => _showAllTransactions(context),
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
                amount: tx.type == TransactionType.income
                    ? '+ ${formatMinorAmount(tx.amountMinor)}'
                    : '- ${formatMinorAmount(tx.amountMinor)}',
                frequency: formatMonthDay(tx.createdAt.toLocal()),
                icon: Icons.abc_rounded,
              ),
          ],
        ),
      ],
    );
  }
}

class _EmptyTransactions extends StatelessWidget {
  const _EmptyTransactions();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No transactions yet',
            style: TextStyle(color: AppColors.primaryText, fontSize: 14),
          ),
          SizedBox(height: 4),
          Text(
            'Your recent transactions will appear here.',
            style: TextStyle(color: AppColors.secondaryText, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
