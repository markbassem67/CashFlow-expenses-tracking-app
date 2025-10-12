import 'package:expenses_tracking_app/core/utils/helpers.dart';
import 'package:expenses_tracking_app/data/models/reminder_model.dart';
import 'package:expenses_tracking_app/data/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionListView extends StatelessWidget {
  final bool isReminderOn;
  final List<Transaction> transactions;
  final List<Reminder> reminders;
  final double width;

  const TransactionListView({
    super.key,
    required this.isReminderOn,
    required this.transactions,
    required this.reminders,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final items = isReminderOn ? reminders : transactions;
    final emptyMessage = isReminderOn
        ? 'No reminders upcoming'
        : 'No transactions yet';
    final isTransactionList = !isReminderOn;

    return Expanded(
      child: items.isEmpty
          ? Center(
              child: Text(
                emptyMessage,
                style: TextStyle(
                  color: const Color(0xFF666666),
                  fontSize: width * 0.04,
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: width * 0.055),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _TransactionListItem(
                  item: item,
                  width: width,
                  isTransaction: isTransactionList,
                );
              },
            ),
    );
  }
}

class _TransactionListItem extends StatelessWidget {
  final dynamic item;
  final double width;
  final bool isTransaction;

  const _TransactionListItem({
    required this.item,
    required this.width,
    required this.isTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      splashColor: Colors.transparent,
      onTap: () {
        // TODO: add functionality later
        /* Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const TransactionDetails(),
          ),
        ); */
      },
      title: Text(
        _getTitle(item),
        style: TextStyle(
          fontSize: width * 0.045,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.32,
        ),
      ),
      subtitle: Text(
        DateFormat('EEE, MMM d, yyyy').format(_getDate(item)),
        style: TextStyle(
          color: const Color(0xFF666666),
          fontSize: width * 0.037,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.26,
        ),
      ),
      trailing: Text(
        _getAmountText(item),
        style: TextStyle(
          color: _getAmountColor(item),
          fontSize: width * 0.048,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getTitle(dynamic item) {
    if (isTransaction) {
      return (item as Transaction).name.capitalize();
    } else {
      return (item as Reminder).title.capitalize();
    }
  }

  DateTime _getDate(dynamic item) {
    if (isTransaction) {
      return (item as Transaction).date;
    } else {
      return (item as Reminder).dateTime;
    }
  }

  String _getAmountText(dynamic item) {
    if (isTransaction) {
      final tx = item as Transaction;
      return tx.type == TransactionType.income
          ? '+\$${tx.amount.toStringAsFixed(2)}'
          : '-\$${tx.amount.toStringAsFixed(2)}';
    } else {
      final reminder = item as Reminder;
      return '-\$${reminder.amount.toStringAsFixed(2)}';
    }
  }

  Color _getAmountColor(dynamic item) {
    if (isTransaction) {
      final tx = item as Transaction;
      return tx.type == TransactionType.income
          ? const Color(0xFF24A869)
          : const Color(0xFFF95B51);
    } else {
      return const Color(0xFFF95B51);
    }
  }
}
