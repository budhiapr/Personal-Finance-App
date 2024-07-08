import 'package:personal_finance_app/core/models/transaction_model.dart';
import 'package:personal_finance_app/utils/extensions/datetime_extension.dart';
import 'package:personal_finance_app/utils/types/transaction_type.dart';

/// Returns a list of sample transactions for testing purposes
List<Transaction> getSampleTransactions() {
  return [
    Transaction(
      id: 1,
      title: 'Groceries',
      amount: 100.16,
      date: DateTime.now().withoutTime,
      type: TransactionType.expense,
    ),
    Transaction(
      id: 2,
      title: 'Salary',
      amount: 2412.21,
      date: DateTime.now().withoutTime,
      type: TransactionType.income,
    ),
    Transaction(
      id: 3,
      title: 'Rent',
      amount: 1030,
      date: DateTime.now().withoutTime,
      type: TransactionType.expense,
    ),
    Transaction(
      id: 4,
      title: 'Utilities',
      amount: 251.66,
      date: DateTime.now().withoutTime,
      type: TransactionType.expense,
    ),
    Transaction(
      id: 5,
      title: 'Dining',
      amount: 75.99,
      date: DateTime.now().withoutTime,
      type: TransactionType.expense,
    ),
  ];
}
