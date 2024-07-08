import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:personal_finance_app/core/models/transaction_model.dart';
import 'package:personal_finance_app/core/services/sample_transactions_service.dart';
import 'package:personal_finance_app/utils/const/server_consts.dart';
import 'package:personal_finance_app/utils/logs/logger.dart';
import 'package:personal_finance_app/utils/types/transaction_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_notifier.g.dart';

/// A class that notifies listeners of changes to transactions.
@Riverpod(keepAlive: true)
class TransactionsNotifier extends _$TransactionsNotifier {
  @override
  List<Transaction> build() {
    fetchTransactions();
    return [];
  }

  /// Adds a transaction to the list of transactions.
  /// The transaction is added to the end of the list.
  void addTransaction(Transaction transaction) {
    state = [...state, transaction];
    Logger.log('Added transaction: $transaction');
  }

  /// Fetch transactions from the server.
  /// The transactions are fetched from the [remoteTransactionsFileUrl].
  /// The fetched transactions are added to the list of transactions.
  Future<void> fetchTransactions() async {
    final _dio = Dio();
    try {
      final response = await _dio.get(remoteTransactionsFileUrl);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            response.data as Map<String, dynamic>;
        final List<dynamic> transactionsData =
            responseData['transactions'] as List<dynamic>;
        final transactions = transactionsData
            .map((transactionJson) =>
                Transaction.fromJson(transactionJson as Map<String, dynamic>))
            .toList();
        state = transactions;
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      throw Exception('Failed to load transactions: $e');
    }
  }

  /// Returns the total amount of all transactions with 2 decimal places
  double getTotalAmount() {
    final total =
        state.fold(0.0, (sum, transaction) => sum + transaction.amount);
    return double.parse(total.toStringAsFixed(2));
  }

  /// Returns a unique transaction ID for a new transaction
  /// The ID is the smallest positive integer that is not already used by any transaction
  int getUniqueTransactionId() {
    final ids = state.map((transaction) => transaction.id).toSet();
    int newId = 1;

    while (ids.contains(newId)) {
      newId++;
    }

    return newId;
  }
}
