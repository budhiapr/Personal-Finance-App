// import 'package:dio/dio.dart';
// import 'package:personal_finance_app/core/models/transaction_model.dart';
// import 'package:personal_finance_app/utils/const/server_consts.dart';

// class TransactionService {
//   final Dio _dio = Dio(BaseOptions(responseType: ResponseType.json));

//   fetchTransactions() async {
//     try {
//       final response = await _dio.get(remoteTransactionsFileUrl);

//       if (response.statusCode == 200) {
//         final responseData = response.data as Map<String, dynamic>;

//         final transactionsData = responseData['transactions'] as List<dynamic>;
//         final transactions = transactionsData.map((transactionJson) =>
//             TransactionModel.fromJson(transactionJson as Map<String, dynamic>));
//         return transactions;
//       } else {
//         throw Exception('Failed to load transactions');
//       }
//     } catch (e) {
//       throw Exception('Failed to load transactions: $e');
//     }
//   }
// }
