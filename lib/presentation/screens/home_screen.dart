import 'package:expenses_tracking_app/core/utils/helpers.dart';
import 'package:expenses_tracking_app/presentation/screens/transaction_details_screen.dart';
import 'package:expenses_tracking_app/presentation/widgets/arc_container.dart';
import 'package:expenses_tracking_app/presentation/widgets/balance_card.dart';
import 'package:flutter/cupertino.dart';
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
    final width = context.screenWidth;
    final height = context.screenHeight;

    return BlocBuilder<FinanceCubit, FinanceState>(
      builder: (context, state) {
        if (state is FinanceLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is FinanceError) {
          return Center(
            child: Text(
              state.message,
              style: TextStyle(color: Colors.red, fontSize: width * 0.045),
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
                    ArcContainer(
                      height: height * 0.30,
                    ).buildArcContainer(context),
                    Positioned(
                      top: height * 0.08,
                      left: width * 0.06,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.045,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            state.username,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.065,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: height * 0.093,
                      left: width * 0.844,
                      child: IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        //TODO: Add notification functionality
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.bell),

                        color: Colors.white,
                        iconSize: width * 0.07,
                      ),

                      /* ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),

                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFFFFFFF,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: () {},
                              icon: const Icon(CupertinoIcons.bell),

                              color: Colors.white,
                              iconSize: width * 0.07, // responsive icon size
                            ),
                          ),
                        ),
                      ), */
                    ),
                    BalanceCardWidget.buildBalanceCard(
                      state.totalIncome,
                      state.totalExpenses,
                      state.balance,
                    ),
                  ],
                ),

                // Section title
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    width * 0.055,
                    height * 0.12,
                    width * 0.055,
                    height * 0.01,
                  ),
                  child: Text(
                    'Transactions History',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: width * 0.05,
                    ),
                  ),
                ),

                // Transaction list
                Expanded(
                  child: state.transactions.isEmpty
                      ? Center(
                          child: Text(
                            'No transactions yet',
                            style: TextStyle(
                              color: const Color(0xFF666666),
                              fontSize: width * 0.04,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.055,
                          ),
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
                                style: TextStyle(
                                  fontSize: width * 0.045,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.32,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat('EEE d, yyyy').format(tx.date),
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
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
