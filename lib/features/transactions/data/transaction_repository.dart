import 'package:budget_app/core/network/api_response.dart';
import 'package:budget_app/core/network/api_service.dart';
import 'package:budget_app/features/transactions/data/transaction.dart';

class TransactionRepository {
  TransactionRepository(this._api);

  final ApiService _api;

  Future<ApiResponse<List<Transaction>>> getList() async {
    final response = await _api.get('/api/transactions');

    return ApiResponse<List<Transaction>>.fromJson(
      response as Map<String, dynamic>,
      (data) => (data as List<dynamic>)
          .map((item) => Transaction.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResponse<Transaction>> getById(int id) async {
    final response = await _api.get('/api/transactions/$id');

    return ApiResponse<Transaction>.fromJson(
      response as Map<String, dynamic>,
      (data) => Transaction.fromJson(data),
    );
  }
}
