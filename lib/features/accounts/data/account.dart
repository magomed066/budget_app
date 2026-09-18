enum AccountType { cash, bank }

enum Currency { RUB }

class Account {
  final int id;
  final String name;
  final AccountType type;
  final Currency currency;
  final int openingBalanceMinor;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.currency,
    required this.openingBalanceMinor,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'currency': currency.name,
      'openingBalanceMinor': openingBalanceMinor,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    for (final field in [
      'name',
      'type',
      'currency',
      'createdAt',
      'updatedAt',
    ]) {
      if (json[field] is! String) {
        throw FormatException(
          'Account.$field must be a string (missing, null, or wrong type).',
        );
      }
    }
    return Account(
      id: json['id'] as int,
      name: json['name'] as String,
      type: AccountType.values.byName(json['type'] as String),
      currency: Currency.values.byName(json['currency'] as String),
      openingBalanceMinor: json['openingBalanceMinor'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
