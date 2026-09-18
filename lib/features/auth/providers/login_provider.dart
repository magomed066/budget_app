import 'package:budget_app/core/network/api_exception.dart';
import 'package:budget_app/core/network/api_service_provider.dart';
import 'package:budget_app/core/utils/logger.dart';
import 'package:budget_app/features/auth/data/auth_repository.dart';
import 'package:budget_app/features/auth/data/auth_storage.dart';
import 'package:budget_app/features/auth/data/auth_user.dart';
import 'package:budget_app/features/auth/providers/user_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(apiServiceProvider));
});

final loginControllerProvider =
    NotifierProvider.autoDispose<LoginController, AsyncValue<AuthUser?>>(
      LoginController.new,
    );

class LoginController extends Notifier<AsyncValue<AuthUser?>> {
  @override
  AsyncValue<AuthUser?> build() => const AsyncData(null);

  Future<void> login(String email, String password) async {
    if (state.isLoading) return;

    final connectivity = ref.read(connectivityProvider);
    final repository = ref.read(authRepositoryProvider);

    // Covers both checking connectivity and sending the request.
    state = const AsyncLoading();

    final result = await AsyncValue.guard<AuthUser?>(() async {
      final connections = await connectivity.checkConnectivity();

      // The screen may have been closed during the check.
      if (!ref.mounted) return null;

      final hasNetwork = connections.any(
        (connection) => connection != ConnectivityResult.none,
      );

      if (!hasNetwork) {
        throw const ApiException(
          message: 'No network connection. Check your Wi-Fi or mobile data.',
          type: ApiErrorType.network,
        );
      }

      final response = await repository.login(email, password);

      await authStorage.saveUser(response.data);
      ref.invalidate(currentUserProvider);

      return response.data;
    });

    if (!ref.mounted) return;

    state = result;

    if (result.hasError) {
      logger.e('Login failed: ${result.error}');
    }
  }
}
