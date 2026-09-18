import 'package:budget_app/features/auth/data/auth_storage.dart';
import 'package:budget_app/features/auth/data/auth_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserProvider = FutureProvider<AuthUser?>((ref) {
  return authStorage.readUser();
});
