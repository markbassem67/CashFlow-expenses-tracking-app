import 'dart:io';

import 'package:expenses_tracking_app/core/utils/helpers.dart';
import 'package:expenses_tracking_app/logic/cubit/finance_cubit.dart';
import 'package:expenses_tracking_app/logic/cubit/finance_state.dart';
import 'package:expenses_tracking_app/presentation/widgets/nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BiometricsScreen extends StatefulWidget {
  const BiometricsScreen({super.key});

  @override
  State<BiometricsScreen> createState() => _BiometricsScreenState();
}

class _BiometricsScreenState extends State<BiometricsScreen> {
  @override
  Widget build(BuildContext context) {
    final width = context.screenWidth;
    final height = context.screenHeight;
    return BlocListener<FinanceCubit, FinanceState>(
      listener: (context, state) {
        if (state is FinanceLoaded) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainNavBar()),
          );
        }
      },

      child: Stack(
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
            body: Padding(
              padding: EdgeInsets.fromLTRB(width * 0.18, width * 0.35, 0, 0),
              child: Column(
                children: [
                  Icon(
                    Platform.isAndroid ? Icons.lock : CupertinoIcons.lock_fill,
                    size: width * 0.16,
                    color: Colors.white,
                  ),
                  SizedBox(height: height * 0.010),
                  Text(
                    'App Locked',
                    style: TextStyle(
                      fontSize: width * 0.11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: height * 0.014),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.17,
                        vertical: height * 0.012,
                      ),
                    ),
                    onPressed: () {
                      context.read<FinanceCubit>().unlockApp();
                    },
                    child: Text(
                      'Unlock',
                      style: TextStyle(
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF429690),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
