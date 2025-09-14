import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BalanceCardWidget {
  static Widget buildBalanceCard(double income, double expenses, double totalBalance) {
    return Positioned(
      top: 155,
      left: 30,
      child: Container(
        width: 374,
        height: 202,
        decoration: BoxDecoration(
          color: const Color(0xFF2E7E78),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              spreadRadius: 2.5,
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 9,
              top: 118.5,
              child: Container(
                width: 356,
                height: 83.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            // Total Balance section
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text(
                        'Total Balance',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.32,
                        ),
                      ),
                      SizedBox(width: 4), // placeholder for optional icon
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    '\$ $totalBalance',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.50,
                    ),
                  ),
                ],
              ),
            ),

            // Income & Expenses labels
            const Positioned(
              left: 19 ,
              top: 121,
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.arrow_down_circle_fill,
                    color: Color(0xFFD0E5E3),
                    size: 16,
                  ),
                  Text(
                    ' Income',
                    style: TextStyle(
                      color: Color(0xFFD0E5E3),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.8,
                    ),
                  ),
                ],
              ),
            ),
            const Positioned(
              right: 19,
              top: 119,
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.arrow_up_circle_fill,
                    color: Color(0xFFD0E5E3),
                    size: 16,
                  ),
                  Text(
                    ' Expenses',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color(0xFFD0E5E3),
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.9,
                    ),
                  ),
                ],
              ),
            ),

            // Income & Expenses amounts
            Positioned(
              left: 20,
              top: 148,
              child: Text(
                '\$ $income',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  letterSpacing: -1,
                ),
              ),
            ),
            Positioned(
              right: 20,
              top: 148,
              child: Text(
                '\$ $expenses',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  letterSpacing: -1,
                ),
              ),
            ),

            // Optional small circular indicators
          ],
        ),
      ),
    );
  }
}
