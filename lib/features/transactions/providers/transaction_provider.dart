import 'dart:async';

import 'package:budget_app/core/network/api_exception.dart';
import 'package:budget_app/core/network/api_service_provider.dart';
import 'package:budget_app/core/utils/logger.dart';
import 'package:budget_app/features/transactions/data/transaction.dart';
import 'package:budget_app/features/transactions/data/transaction_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionRepositoryProvier =
    Provider.autoDispose<TransactionRepository>((ref) {
      return TransactionRepository(ref.watch(apiServiceProvider));
    });

final transactionControllerProvider =
    NotifierProvider.autoDispose<
      TransactionController,
      AsyncValue<List<Transaction>>
    >(TransactionController.new);

class TransactionController extends Notifier<AsyncValue<List<Transaction>>> {
  @override
  AsyncValue<List<Transaction>> build() {
    // Kick off the fetch. Return loading immediately, update when done.
    Future.microtask(_fetch);
    return const AsyncLoading();
  }

  Future<void> _fetch() async {
    final connectivity = ref.read(connectivityProvider);
    final repository = ref.read(transactionRepositoryProvier);

    final result = await AsyncValue.guard<List<Transaction>>(() async {
      final connections = await connectivity.checkConnectivity();
      if (!ref.mounted) return <Transaction>[];

      final hasNetwork = connections.any((c) => c != ConnectivityResult.none);
      if (!hasNetwork) {
        throw const ApiException(
          message: 'No network connection. Check your Wi-Fi or mobile data.',
          type: ApiErrorType.network,
        );
      }

      final response = await repository.getList();
      return response.data;
    });

    if (!ref.mounted) return;
    state = result;
    if (result.hasError) {
      logger.e('Failed to load transactions: ${result.error}');
    }
  }

  Future<void> refresh() => _fetch();
}
