import 'package:expenses_tracking_app/core/utils/helpers.dart';
import 'package:expenses_tracking_app/data/models/transaction_model.dart';
import 'package:expenses_tracking_app/logic/cubit/finance_cubit.dart';
import 'package:expenses_tracking_app/logic/cubit/finance_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    final width = context.screenWidth;
    final height = context.screenHeight;
    return BlocBuilder<FinanceCubit, FinanceState>(
      builder: (context, state) {
        if (state is FinanceLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is FinanceLoaded) {
          final expenses =
              state.transactions
                  .where((tx) => tx.type == TransactionType.expense)
                  .toList()
                ..sort((a, b) => b.amount.compareTo(a.amount));

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Statistics',
                style: TextStyle(
                  fontSize: width * 0.057,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF222222),
                ),
              ),
              backgroundColor: Colors.white,
            ),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  expenses.isNotEmpty
                      ? Text(
                          'Top Spendings',
                          style: TextStyle(
                            fontSize: width * 0.048,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : const SizedBox.shrink(),
                  SizedBox(height: height * 0.013),
                  Expanded(
                    child: expenses.isEmpty
                        ? Center(
                            child: Text(
                              'No expenses yet',
                              style: TextStyle(
                                color: const Color(0xFF666666),
                                fontSize: width * 0.04,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: expenses.length,
                            itemBuilder: (context, index) {
                              final tx = expenses[index];
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
                                  tx.name.capitalize(),
                                  style: TextStyle(
                                    fontSize: width * 0.045,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.32,
                                  ),
                                ),
                                subtitle: Text(
                                  DateFormat(
                                    'EEE, MMM d, yyyy',
                                  ).format(tx.date),
                                  style: TextStyle(
                                    color: const Color(0xFF666666),
                                    fontSize: width * 0.037,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: -0.26,
                                  ),
                                ),
                                trailing: Text(
                                  tx.type == TransactionType.income
                                      ? '+\$${tx.amount.toStringAsFixed(2)}'
                                      : '-\$${tx.amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: tx.type == TransactionType.income
                                        ? const Color(0xFF24A869)
                                        : const Color(0xFFF95B51),
                                    fontSize: width * 0.048,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        }
        ;
        return const SizedBox.shrink();
      },
    );
  }
}
