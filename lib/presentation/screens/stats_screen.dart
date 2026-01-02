import 'dart:io';
import 'package:currency_picker/currency_picker.dart';
import 'package:expenses_tracking_app/core/utils/helpers.dart';
import 'package:expenses_tracking_app/data/models/transaction_model.dart';
import 'package:expenses_tracking_app/logic/cubit/finance_cubit.dart';
import 'package:expenses_tracking_app/logic/cubit/finance_state.dart';
import 'package:expenses_tracking_app/presentation/screens/biometrics_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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
              surfaceTintColor: Colors.transparent,
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    _showBiometricsModal(context, height, width);
                  }, //TODO: add settings functionality
                  highlightColor: Colors.transparent,
                  icon: Icon(
                    Platform.isIOS ? CupertinoIcons.settings : Icons.settings,
                    size: width * 0.067,
                  ),
                ),
              ],
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
                                      ? '+${state.currency}${tx.amount.toStringAsFixed(2)}'
                                      : '-${state.currency}${tx.amount.toStringAsFixed(2)}',
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

void _showBiometricsModal(BuildContext context, double height, double width) {
  String? selectedCurrency;
  showPlatformModalSheet(
    context: context,
    builder: (modalContext) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          0.21,
          0,
          0.21,
          0,
        ), //TODO: make it scale properly
        child: Container(
          height: height * 0.2,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: const Color(0xFF1E605B), width: 4),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Use Biometrics',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                        fontSize: width * 0.052,
                        color: const Color(0xFF222222),
                      ),
                    ),
                    SizedBox(width: width * 0.125),
                    BlocBuilder<FinanceCubit, FinanceState>(
                      builder: (context, state) {
                        return PlatformSwitch(
                          value: state is FinanceLoaded
                              ? state.biometricsOn
                              : false,
                          onChanged: (value) {
                            if (value) {
                              context.read<FinanceCubit>().unlockApp();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const BiometricsScreen(),
                                ),
                              );
                            }
                            context.read<FinanceCubit>().toggleBiometrics(
                              value,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Change Currency',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                        fontSize: width * 0.052,
                        color: const Color(0xFF222222),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showCurrencyPicker(
                          context: context,
                          onSelect: (Currency currency) {
                            selectedCurrency = currency.symbol;
                            context.read<FinanceCubit>().setUserCurrency(
                              currency.symbol,
                            );
                            (context as Element).markNeedsBuild();
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade50,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedCurrency ?? "Select currency",
                              style: TextStyle(
                                fontSize: width * 0.036,
                                decoration: TextDecoration.none,

                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF2A7C76),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
