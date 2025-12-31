import 'package:expenses_tracking_app/core/utils/helpers.dart';
import 'package:flutter/material.dart';

class SplashUi extends StatelessWidget {
  const SplashUi({super.key});

  @override
  Widget build(BuildContext context) {
    final width = context.screenWidth;
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF429690), Color(0xFF2A7C76)],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Text(
              'CashFlow',
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.08,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
