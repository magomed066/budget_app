import 'package:budget_app/core/network/api_exception.dart';
import 'package:budget_app/core/network/api_service_provider.dart';
import 'package:budget_app/core/utils/logger.dart';
import 'package:budget_app/features/accounts/data/account.dart';
import 'package:budget_app/features/accounts/data/accounts_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountRepositoryProvier = Provider<AccountsRepository>((ref) {
  return AccountsRepository(ref.watch(apiServiceProvider));
});

final accountControllerProvider =
    NotifierProvider<AccountController, AsyncValue<List<Account>>>(
      AccountController.new,
    );

final accountByIdProvider = FutureProvider.autoDispose.family<Account, int>((
  ref,
  id,
) async {
  final repository = ref.watch(accountRepositoryProvier);
  final response = await repository.getById(id);

  logger.d(response.data.name);
  return response.data;
});

class AccountController extends Notifier<AsyncValue<List<Account>>> {
  @override
  AsyncValue<List<Account>> build() => const AsyncData([]);

  Future<void> getList() async {
    if (state.isLoading) return;

    final connectivity = ref.read(connectivityProvider);
    final repository = ref.read(accountRepositoryProvier);

    state = AsyncLoading();

    final result = await AsyncValue.guard<List<Account>>(() async {
      final connections = await connectivity.checkConnectivity();

      // The screen may have been closed during the check.
      if (!ref.mounted) return [];

      final hasNetwork = connections.any(
        (connection) => connection != ConnectivityResult.none,
      );

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
      logger.e('Login failed: ${result.error}');
    }
  }
}
