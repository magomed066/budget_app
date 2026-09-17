import 'package:budget_app/features/auth/data/auth_user.dart';
import 'package:budget_app/core/network/api_response.dart';
import 'package:budget_app/core/network/api_service.dart';

class AuthRepository {
  AuthRepository(this._api);

  final ApiService _api;

  Future<ApiResponse<AuthUser>> login(String email, String password) async {
    final response = await _api.post(
      '/api/auth/login',
      body: {'email': email, 'password': password},
    );

    return ApiResponse<AuthUser>.fromJson(
      response as Map<String, dynamic>,
      (data) => AuthUser.fromJson(data as Map<String, dynamic>),
    );
  }
}
