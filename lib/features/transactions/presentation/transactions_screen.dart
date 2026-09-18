import 'package:budget_app/app/theme/app_colors.dart';
import 'package:budget_app/core/utils/async_error_handler.dart';
import 'package:budget_app/core/utils/date_formatter.dart';
import 'package:budget_app/features/transactions/data/transaction.dart';
import 'package:budget_app/features/transactions/presentation/widgets/transaction_card.dart';
import 'package:budget_app/features/transactions/providers/transaction_provider.dart';
import 'package:budget_app/shared/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// A presentation-only transaction screen.
///
/// Data loading, filtering, searching, sorting, and error handling belong to
/// the caller. This widget only renders the values it receives.
class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final content = ListView(
    //   physics: const AlwaysScrollableScrollPhysics(),
    //   padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
    //   children: [
    //     Text(
    //       '${transactions.length} ${transactions.length == 1 ? 'transaction' : 'transactions'}',
    //       style: const TextStyle(
    //         color: AppColors.secondaryText,
    //         fontSize: 13,
    //         fontWeight: FontWeight.w500,
    //       ),
    //     ),
    //     const SizedBox(height: 10),
    //     for (final transaction in transactions) ...[
    //       _TransactionListItem(transaction: transaction),
    //       const SizedBox(height: 10),
    //     ],
    //   ],
    // );

    ref.listen(transactionControllerProvider, (previous, next) {
      handleAsyncError(
        next,
        logMessage: 'Transactions failed to load',
        fallbackMessage: 'Could not load your transactions. Please try again.',
      );
    });

    final transactionsState = ref.watch(transactionControllerProvider);
    final transactions = transactionsState.value ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(height: 60, title: 'Transactions'),
      body: Container(
        padding: EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${transactions.length} ${transactions.length == 1 ? 'transaction' : 'transactions'}',
              style: const TextStyle(
                color: AppColors.secondaryText,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 15),

            for (final transaction in transactions) ...[
              Skeletonizer(
                enabled: transactionsState.isLoading,
                child: _TransactionListItem(transaction: transaction),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class _TransactionListItem extends StatelessWidget {
  const _TransactionListItem({required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return TransactionTile(
      title: transaction.category.name,
      description: transaction.note.isEmpty ? "" : transaction.note,
      amountMinor: transaction.amountMinor,
      type: transaction.type,
      date: formatMonthDay(transaction.date.toLocal()),
    );
  }
}
