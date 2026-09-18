class AuthUser {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String accessToken;
  final String refreshToken;

  const AuthUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
    required this.accessToken,
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    for (final field in [
      'email',
      'firstName',
      'lastName',
      'createdAt',
      'updatedAt',
      'accessToken',
      'refreshToken',
    ]) {
      if (json[field] is! String) {
        throw FormatException(
          'AuthUser.$field must be a string (missing, null, or wrong type).',
        );
      }
    }
    return AuthUser(
      id: json['id'] as int,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}
