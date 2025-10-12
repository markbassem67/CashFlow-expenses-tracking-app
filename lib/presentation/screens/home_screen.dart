import 'package:expenses_tracking_app/core/utils/helpers.dart';
import 'package:expenses_tracking_app/presentation/widgets/arc_container.dart';
import 'package:expenses_tracking_app/presentation/widgets/balance_card.dart';
import 'package:expenses_tracking_app/presentation/widgets/build_homescreen_lists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expenses_tracking_app/logic/cubit/finance_cubit.dart';
import 'package:expenses_tracking_app/logic/cubit/finance_state.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  ValueNotifier<bool> isReminderOn = ValueNotifier(false);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //bool reminderOn = false;

  @override
  void initState() {
    super.initState();
    widget.isReminderOn.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    widget.isReminderOn.dispose();
    super.dispose();
  }

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
                        onPressed: () {
                          widget.isReminderOn.value =
                              !widget.isReminderOn.value;
                        },
                        icon: !widget.isReminderOn.value
                            ? const Icon(CupertinoIcons.bell)
                            : const Icon(CupertinoIcons.list_dash),

                        color: Colors.white,
                        iconSize: width * 0.07,
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
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    width * 0.055,
                    height * 0.12,
                    width * 0.055,
                    height * 0.01,
                  ),
                  child: Text(
                    !widget.isReminderOn.value
                        ? 'Transactions History'
                        : 'Reminders List',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: width * 0.05,
                    ),
                  ),
                ),
                Expanded(
                  child: TransactionListView(
                    isReminderOn: widget.isReminderOn.value,
                    transactions: state.transactions,
                    reminders: state.reminders,
                    width: width,
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
