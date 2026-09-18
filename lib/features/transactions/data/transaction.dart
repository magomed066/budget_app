import 'package:budget_app/features/accounts/data/account.dart';
import 'package:budget_app/features/categories/data/category.dart';

enum TransactionType { income, expense }

class Transaction {
  final int id;
  final int amountMinor;
  final DateTime date;
  final TransactionType type;
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Account account;
  final Category category;

  const Transaction({
    required this.id,
    required this.amountMinor,
    required this.date,
    required this.note,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.account,
    required this.category,
  });

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'amountMinor': amountMinor,
      'date': date.toIso8601String().split('T').first,
      'note': note,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'account': account.toJSON(),
      'category': category.toJSON(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    for (final field in ['type', 'date', 'note', 'createdAt', 'updatedAt']) {
      if (json[field] is! String) {
        throw FormatException(
          'Transaction.$field must be a string (missing, null, or wrong type).',
        );
      }
    }

    for (final field in ['account', 'category']) {
      if (json[field] is! Map<String, dynamic>) {
        throw FormatException(
          'Transaction.$field must be an object (missing, null, or wrong type).',
        );
      }
    }

    return Transaction(
      id: json['id'] as int,
      amountMinor: json['amountMinor'] as int,
      date: DateTime.parse(json['date'] as String),
      note: json['note'] as String,
      type: TransactionType.values.byName(json['type'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      account: Account.fromJson(json['account'] as Map<String, dynamic>),
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
    );
  }
}
