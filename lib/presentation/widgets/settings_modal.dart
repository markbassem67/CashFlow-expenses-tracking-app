import 'dart:io';

import 'package:currency_picker/currency_picker.dart';
import 'package:expenses_tracking_app/logic/cubit/finance_cubit.dart';
import 'package:expenses_tracking_app/logic/cubit/finance_state.dart';
import 'package:expenses_tracking_app/presentation/screens/biometrics_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class SettingsModal extends StatelessWidget {
  final double height;
  final double width;
  final String selectedCurrency;
  final BuildContext parentContext;

  const SettingsModal({
    super.key,
    required this.height,
    required this.width,
    required this.selectedCurrency,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: const Border(
          left: BorderSide(color: Color(0xFF1E605B), width: 5),
          right: BorderSide(color: Color(0xFF1E605B), width: 5),
          top: BorderSide(color: Color(0xFF1E605B), width: 5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Biometrics row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _title('Use Biometrics'),
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
                              builder: (_) => const BiometricsScreen(),
                            ),
                          );
                        }
                        context.read<FinanceCubit>().toggleBiometrics(value);
                      },
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: height * 0.02),

            /// Currency row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _title('Change Currency'),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    showCurrencyPicker(
                      context: parentContext,
                      theme: CurrencyPickerThemeData(
                        backgroundColor: Colors.white,
                        bottomSheetHeight: height * 0.5,
                      ),
                      onSelect: (currency) {
                        parentContext.read<FinanceCubit>().setUserCurrency(
                          currency.symbol,
                        );
                      },
                    );
                  },
                  child: Container(
                    width: width * 0.20,
                    height: height * 0.055,
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
                          selectedCurrency,
                          style: TextStyle(
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2A7C76),
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Icon(
                          Platform.isAndroid
                              ? Icons.arrow_drop_down
                              : CupertinoIcons.chevron_down,
                          size: width * 0.04,
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
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: width * 0.05,
        color: const Color(0xFF222222),
        decoration: TextDecoration.none,
      ),
    );
  }
}
