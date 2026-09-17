class ApiResponse<T> {
  final bool success;
  final T data;

  const ApiResponse({required this.success, required this.data});

  Map<String, dynamic> toJson(Object? Function(T) encodeData) {
    return {'success': success, 'data': encodeData(data)};
  }

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) parseData,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool,
      data: parseData(json['data']),
    );
  }
}
