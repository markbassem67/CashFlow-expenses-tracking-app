import 'package:expenses_tracking_app/presentation/widgets/add_expenses_card.dart';
import 'package:expenses_tracking_app/presentation/widgets/arc_container.dart';
import 'package:flutter/material.dart';
import '../../core/utils/helpers.dart'; // for MediaQueryHelper

class AddExpensesScreen extends StatefulWidget {
  const AddExpensesScreen({super.key});

  @override
  State<AddExpensesScreen> createState() => _AddExpensesScreenState();
}

class _AddExpensesScreenState extends State<AddExpensesScreen> {
  @override
  Widget build(BuildContext context) {
    final width = context.screenWidth;
    final height = context.screenHeight;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // Arc background
          ArcContainer(height: height * 0.25).buildArcContainer(context),

          // Title
          Positioned(
            left: width * 0.30,
            top: height * 0.08,
            child: Text(
              'Add Expense',
              style: TextStyle(
                fontSize: width * 0.06,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // Add Expenses Card
          Positioned(
            top: height * 0.007,
            //left: width * 0.01,
            child: const AddExpensesCard(),
          ),
        ],
      ),
    );
  }
}
