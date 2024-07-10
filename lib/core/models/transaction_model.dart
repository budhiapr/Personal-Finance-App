import 'package:personal_finance_app/utils/types/transaction_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
class TransactionModel with _$TransactionModel {
  /// Creates a transaction model.
  @Assert('amount >= 0')
  const factory TransactionModel({
    required int id,
    required String title,
    required double amount,
    DateTime? date,
    TransactionType? type,
  }) = _TransactionModel;

  /// Creates a transaction model from JSON.
  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}
