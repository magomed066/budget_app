import 'package:budget_app/core/network/api_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final api = ApiService(
    baseUrl: 'http://127.0.0.1:3000',
    timeout: const Duration(seconds: 20),
  );
  ref.onDispose(api.close);
  return api;
});

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});
