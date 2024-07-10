import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:personal_finance_app/core/models/transaction_model.dart';
import 'package:personal_finance_app/core/providers/transactions_notifier.dart';
import 'package:personal_finance_app/utils/extensions/datetime_extension.dart';
import 'package:personal_finance_app/utils/extensions/l10n_extension.dart';
import 'package:personal_finance_app/utils/extensions/routing_extension.dart';
import 'package:personal_finance_app/utils/types/transaction_type.dart';
import 'package:fluttertoast/fluttertoast.dart';

// TODO: add validation to the form
final amountController = TextEditingController();

/// Shows a dialog to add a new transaction
void showAddTransactionDialog(
    BuildContext context,
    TransactionsNotifier transactionsNotifier,
    List<TransactionModel> transactions) {
  final formKey = GlobalKey<FormState>();
  var title = '';
  var amount = 0.0;
  var currentBalance = transactionsNotifier.getTotalAmount(transactions);
  var type = TransactionType.expense;
  var date = DateTime.now().withoutTime;

  showDialog<AlertDialog>(
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: AlertDialog(
          title: Text(context.l10n.addTransactionTitle),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration:
                      InputDecoration(labelText: context.l10n.titleInputField),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    title = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: context.l10n.amountInputField),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    amount = double.parse(value!);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field is required';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<TransactionType>(
                  decoration: InputDecoration(
                    labelText: context.l10n.typeInputField,
                  ),
                  value: type,
                  items: TransactionType.values.map((TransactionType value) {
                    return DropdownMenuItem<TransactionType>(
                      value: value,
                      child: Text(value.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (TransactionType? newValue) {
                    type = newValue!;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now().withoutTime,
                    );
                    date = pickedDate!;
                  },
                  child: Text(context.l10n.dateInputField),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(context.l10n.cancelButton),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(context.l10n.addButton),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();

                  if (amount.toDouble() > currentBalance.toDouble()) {
                    Fluttertoast.showToast(
                        msg: "Insufficient Balance",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 3,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    transactionsNotifier.addTransaction(
                      TransactionModel(
                        id: transactionsNotifier.getUniqueTransactionId(),
                        date: date,
                        amount: amount,
                        title: title,
                        type: type,
                      ),
                    );
                    context.pop();
                  }
                }
              },
            ),
          ],
        ),
      );
    },
  );
}
