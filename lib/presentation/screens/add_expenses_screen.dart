import 'package:expenses_tracking_app/presentation/widgets/add_expenses_card.dart';
import 'package:expenses_tracking_app/presentation/widgets/arc_container.dart';
import 'package:flutter/material.dart';

class AddExpensesScreen extends StatefulWidget {
  const AddExpensesScreen({super.key});

  @override
  State<AddExpensesScreen> createState() => _AddExpensesScreenState();
}

class _AddExpensesScreenState extends State<AddExpensesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              ArcContainer(height: 287).buildArcContainer(),
              const Positioned(
                left: 135,
                top: 70,
                child: Text(
                  'Add Expense',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const AddExpensesCard(),
              //addExpensesCard.buildExpensesCard(context),
            ],
          ),
        ],
      ),
    );
  }
}
