import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance_app/core/models/transaction_model.dart';
import 'package:personal_finance_app/core/providers/transactions_notifier.dart';
import 'package:personal_finance_app/ui/screens/home/widgets/new_transaction_pop_up.dart';
import 'package:personal_finance_app/ui/screens/home/widgets/transaction_widget.dart';
import 'package:personal_finance_app/utils/extensions/l10n_extension.dart';
import 'package:personal_finance_app/utils/extensions/style_extension.dart';
import 'package:personal_finance_app/utils/logs/logger.dart';

/// Routing for the HomeScreen
abstract class HomeScreenRouting {
  /// Path for the router
  static const String routePath = '/';

  /// Builder for navigation to screen
  static PageRoute<T> buildRoute<T>({
    RouteSettings? settings,
  }) {
    Logger.log(HomeScreen);
    return MaterialPageRoute<void>(
      builder: (BuildContext context) => const HomeScreen(),
      settings: settings,
    ) as PageRoute<T>;
  }
}

/// Home Screen for the personal finance app
class HomeScreen extends ConsumerWidget {
  /// Creates the HomeScreen
  const HomeScreen({super.key});

  /// The vertical padding for the screen between elements
  static const double verticalPadding = 30;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsNotifier =
        ref.watch(transactionsNotifierProvider.notifier);
    final transactions = ref.watch(transactionsNotifierProvider);

    final balance = ref.read(transactionsNotifierProvider);

    return Scaffold(
      floatingActionButton:
          _floatingActionSection(context, transactionsNotifier, transactions),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                transactionsNotifier.isLoading
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Center(child: const CircularProgressIndicator()))
                    : Column(
                        children: [
                          _headerSection(
                            context,
                            transactionsNotifier.getTotalAmount(balance),
                          ),
                          _tableSection(context, transactions),
                          const SizedBox(height: 100),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _floatingActionSection(
    BuildContext context,
    TransactionsNotifier transactionsNotifier,
    List<TransactionModel> transactions,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FloatingActionButton(
            onPressed: transactionsNotifier.fetchTransactions,
            child: const Icon(Icons.sync),
          ),
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              showAddTransactionDialog(
                  context, transactionsNotifier, transactions);
            },
          ),
        ],
      ),
    );
  }

  Widget _headerSection(BuildContext context, double balance) {
    final isPositive = balance >= 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: verticalPadding),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              context.l10n.pageTitle,
              style: context.textTheme.headlineLarge,
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: verticalPadding),
          Center(
            child: Text(
              '${isPositive ? '+' : '-'}\$${balance.abs().toStringAsFixed(2)}',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableSection(
      BuildContext context, List<TransactionModel> transactions) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                context.l10n.dateColumn,
                style: context.textTheme.titleLarge,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                context.l10n.descriptionColumn,
                style: context.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Text(
                context.l10n.amountColumn,
                style: context.textTheme.titleLarge,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: verticalPadding / 4),
        Divider(color: context.colorScheme.onSurfaceVariant, thickness: 1),
        ...transactions.map((transaction) {
          return TransactionWidget(transaction: transaction);
        }),
      ],
    );
  }
}
