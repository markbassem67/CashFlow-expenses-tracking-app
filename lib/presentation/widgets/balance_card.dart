import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/utils/helpers.dart';

class BalanceCardWidget {
  static Widget buildBalanceCard(
    double income,
    double expenses,
    double totalBalance,
  ) {
    return Builder(
      builder: (context) {
        final width = context.screenWidth;
        final height = context.screenHeight;

        return Positioned(
          top: height * 0.17, // instead of 155
          left: width * 0.055, // instead of 30
          child: Container(
            width: width * 0.9, // instead of 374
            height: height * 0.23, // instead of 202
            decoration: BoxDecoration(
              color: const Color(0xFF2E7E78),
              borderRadius: BorderRadius.circular(width * 0.05),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  spreadRadius: width * 0.006,
                  blurRadius: width * 0.015,
                  offset: Offset(width * 0.01, height * 0.005),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  left: width * 0.025,
                  top: height * 0.15,
                  child: Container(
                    width: width * 0.85,
                    height: height * 0.11,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(width * 0.05),
                    ),
                  ),
                ),

                // Total Balance section
                Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.05,
                    top: height * 0.03,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Total Balance',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.32,
                            ),
                          ),
                          SizedBox(width: width * 0.01),
                        ],
                      ),
                      //SizedBox(height: height * 0.01),
                      Text(
                        '\$ $totalBalance',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.075,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Income label
                Positioned(
                  left: width * 0.05,
                  top: height * 0.16,
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.arrow_down_circle_fill,
                        color: const Color(0xFFD0E5E3),
                        size: width * 0.045,
                      ),
                      Text(
                        ' Income',
                        style: TextStyle(
                          color: const Color(0xFFD0E5E3),
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.8,
                        ),
                      ),
                    ],
                  ),
                ),

                // Expenses label
                Positioned(
                  right: width * 0.05,
                  top: height * 0.16,
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.arrow_up_circle_fill,
                        color: const Color(0xFFD0E5E3),
                        size: width * 0.045,
                      ),
                      Text(
                        ' Expenses',
                        style: TextStyle(
                          color: const Color(0xFFD0E5E3),
                          fontSize: width * 0.045,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.9,
                        ),
                      ),
                    ],
                  ),
                ),

                // Income amount
                Positioned(
                  left: width * 0.05,
                  top: height * 0.185,
                  child: Text(
                    '\$ $income',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                    ),
                  ),
                ),

                // Expenses amount
                Positioned(
                  right: width * 0.05,
                  top: height * 0.185,
                  child: Text(
                    '\$ $expenses',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
