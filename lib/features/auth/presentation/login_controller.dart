import 'package:budget_app/core/network/api_service_provider.dart';
import 'package:budget_app/core/utils/logger.dart';
import 'package:budget_app/features/auth/data/auth_repository.dart';
import 'package:budget_app/features/auth/data/auth_user.dart';
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

    final repository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final response = await repository.login(email, password);
      return response.data;
    });

    // The login route may have been popped while the request was in flight.
    if (!ref.mounted) return;
    state = result;
    if (result.hasError) {
      logger.e('Login failed: ${result.error}');
    }
  }
}
