import 'package:expenses_tracking_app/core/utils/helpers.dart';
import 'package:expenses_tracking_app/presentation/screens/transaction_details_screen.dart';
import 'package:expenses_tracking_app/presentation/widgets/arc_container.dart';
import 'package:expenses_tracking_app/presentation/widgets/balance_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expenses_tracking_app/logic/cubit/finance_cubit.dart';
import 'package:expenses_tracking_app/logic/cubit/finance_state.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';

import '../../data/models/transaction_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceCubit, FinanceState>(
      builder: (context, state) {
        if (state is FinanceLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is FinanceError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is FinanceLoaded) {
          return PlatformScaffold(
            backgroundColor: Colors.white,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top header with Arc + Balance Card
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ArcContainer(height: 287).buildArcContainer(),
                    Positioned(
                      top: 74,
                      left: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hello!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            state.username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    BalanceCardWidget.buildBalanceCard(
                      state.totalIncome,
                      state.totalExpenses,
                      state.balance,
                    ),
                  ],
                ),

                // Section title
                const Padding(
                  padding: EdgeInsets.fromLTRB(22, 100, 22, 8),
                  child: Text(
                    'Transactions History',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 19),
                  ),
                ),

                // Transaction list
                Expanded(
                  child: state.transactions.isEmpty
                      ? const Center(
                          child: Text(
                            'No transactions yet',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 15,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          itemCount: state.transactions.length,
                          itemBuilder: (context, index) {
                            final tx = state.transactions[index];
                            return ListTile(
                              splashColor: Colors.transparent,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const TransactionDetails(),
                                  ),
                                );
                              },
                              title: Text(
                                tx.name.capitalize(),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.32,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat('EEE d, yyyy').format(tx.date),
                                style: const TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 14,
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
