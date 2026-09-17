import 'package:budget_app/services/auth/login_response.dart';
import 'package:budget_app/services/base/api_response.dart';
import 'package:budget_app/services/base/api_service.dart';

class AuthService {
  Future<ApiResponse<AuthUser>> login(String email, String password) async {
    final response = await api.post(
      '/api/auth/login',
      body: {'email': email, 'password': password},
    );

    return ApiResponse<AuthUser>.fromJson(
      response as Map<String, dynamic>,
      (data) => AuthUser.fromJson(data as Map<String, dynamic>),
    );
  }
}

final authService = AuthService();
