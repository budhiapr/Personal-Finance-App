import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:personal_finance_app/utils/types/transaction_type.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
abstract class Transaction with _$Transaction {
  /// Creates a transaction model.
  @Assert('amount >= 0')
  const factory Transaction({
    required int id,
    required String title,
    required double amount,
    required DateTime date,
    required TransactionType type,
  }) = _Transaction;

  /// Creates a transaction model from JSON.
  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}
