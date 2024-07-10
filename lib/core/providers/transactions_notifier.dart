import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:personal_finance_app/core/models/transaction_model.dart';
import 'package:personal_finance_app/utils/const/server_consts.dart';
import 'package:personal_finance_app/utils/logs/logger.dart';
import 'package:personal_finance_app/utils/types/transaction_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transactions_notifier.g.dart';

/// A class that notifies listeners of changes to transactions.
@Riverpod(keepAlive: true)
class TransactionsNotifier extends _$TransactionsNotifier {
  var isLoading = true;
  var isError = "";
  double totalAmount = 0.0;

  @override
  List<TransactionModel> build() {
    fetchTransactions();
    return state;
  }

  /// Adds a transaction to the list of transactions.
  /// The transaction is added to the end of the list.
  void addTransaction(TransactionModel transaction) {
    state = [...state, transaction];

    Logger.log('Added transaction: $transaction');
  }

  /// Fetch transactions from the server.
  /// The transactions are fetched from the [remoteTransactionsFileUrl].
  /// The fetched transactions are added to the list of transactions.
  fetchTransactions() async {
    state = [];

    final _dio = Dio();
    try {
      isLoading = true;
      // log("Status Loading Start: ${transactionState.transactionLoadingState}");
      final response = await _dio.get(remoteTransactionsFileUrl);

      if (response.statusCode == 200) {
        // log("Status Loading End: ${transactionState.transactionLoadingState}");
        final Map<String, dynamic> responseData =
            response.data as Map<String, dynamic>;
        final List<dynamic> transactionsData =
            responseData['transactions'] as List<dynamic>;
        final transactions = transactionsData
            .map((transactionJson) => TransactionModel.fromJson(
                transactionJson as Map<String, dynamic>))
            .toList();

        state = transactions;
        isLoading = false;
      } else {
        isLoading = false;
        isError = 'Failed to load transactions';
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      isLoading = false;
      isError = e.toString();
      throw Exception('Failed to load transactions: $e');
    }
  }

  resetTotalAmount() {
    totalAmount = 0.0;
  }

  /// Returns the total amount of all transactions with 2 decimal places
  double getTotalAmount(List<TransactionModel> transactions) {
    resetTotalAmount();
    for (var transaction in transactions) {
      if (transaction.type == TransactionType.income) {
        totalAmount += transaction.amount;
      } else if (transaction.type == TransactionType.expense) {
        totalAmount -= transaction.amount;
      }
    }

    return totalAmount;
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
