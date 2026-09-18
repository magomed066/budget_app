import 'package:budget_app/core/network/api_response.dart';
import 'package:budget_app/core/network/api_service.dart';
import 'package:budget_app/features/accounts/data/account.dart';

class AccountsRepository {
  AccountsRepository(this._api);

  final ApiService _api;

  Future<ApiResponse<List<Account>>> getList() async {
    final response = await _api.get('/api/accounts');

    return ApiResponse<List<Account>>.fromJson(
      response as Map<String, dynamic>,
      (data) => (data as List<dynamic>)
          .map((item) => Account.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResponse<Account>> getById(int id) async {
    final response = await _api.get('/api/accounts/$id');

    return ApiResponse<Account>.fromJson(
      response as Map<String, dynamic>,
      (data) => Account.fromJson(data),
    );
  }
}
