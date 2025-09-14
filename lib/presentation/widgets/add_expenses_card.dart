import 'package:expenses_tracking_app/presentation/widgets/platform_alert_dialog.dart';
import 'package:expenses_tracking_app/presentation/widgets/platform_datepicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/transaction_model.dart';
import '../../logic/cubit/finance_cubit.dart';
import 'custom_button.dart';
import '../../core/utils/helpers.dart'; // MediaQueryHelper

class AddExpensesCard extends StatefulWidget {
  const AddExpensesCard({Key? key}) : super(key: key);

  @override
  State<AddExpensesCard> createState() => _AddExpensesCardState();
}

class _AddExpensesCardState extends State<AddExpensesCard> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? selectedType;
  final uuid = const Uuid();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    amountController.dispose();
    dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = context.screenWidth;
    final height = context.screenHeight;

    OutlineInputBorder greenBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF29756F), width: 1),
      borderRadius: BorderRadius.circular(width * 0.02),
    );

    OutlineInputBorder greyBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      borderRadius: BorderRadius.circular(width * 0.02),
    );

    return Form(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          width * 0.055,
          height * 0.14,
          width * 0.055,
          0,
        ),
        child: Container(
          width: width * 0.9,
          height: height * 0.68,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(width * 0.05),
            ),
            shadows: [
              BoxShadow(
                color: const Color(0x14000000),
                blurRadius: width * 0.09,
                offset: Offset(0, height * 0.03),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              width * 0.055,
              height * 0.005,
              width * 0.055,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.04),
                Text(
                  'Name',
                  style: TextStyle(
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFF666666),
                  ),
                ),
                SizedBox(height: height * 0.012),
                SizedBox(
                  height: height * 0.065,
                  child: TextFormField(
                    controller: nameController,
                    cursorColor: const Color(0xFF29756F),
                    decoration: InputDecoration(
                      hintText: 'Enter name',
                      enabledBorder: greyBorder,
                      focusedBorder: greenBorder,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.025),
                Text(
                  'Amount',
                  style: TextStyle(
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFF666666),
                  ),
                ),
                SizedBox(height: height * 0.012),
                SizedBox(
                  height: height * 0.065,
                  child: TextFormField(
                    controller: amountController,
                    cursorColor: const Color(0xFF29756F),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter amount',
                      enabledBorder: greyBorder,
                      focusedBorder: greenBorder,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.025),
                Text(
                  'Type',
                  style: TextStyle(
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFF666666),
                  ),
                ),
                SizedBox(height: height * 0.012),
                SizedBox(
                  height: height * 0.065,
                  child: DropdownButtonFormField<String>(
                    value: selectedType,
                    items: const [
                      DropdownMenuItem(
                        value: 'Expense',
                        child: Text('Expense'),
                      ),
                      DropdownMenuItem(value: 'Income', child: Text('Income')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Select type',
                      enabledBorder: greyBorder,
                      focusedBorder: greenBorder,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: width * 0.03,
                        vertical: height * 0.02,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.025),
                Text(
                  'Date',
                  style: TextStyle(
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFF666666),
                  ),
                ),
                SizedBox(height: height * 0.012),
                SizedBox(
                  height: height * 0.065,
                  child: TextFormField(
                    controller: dateController,
                    decoration: InputDecoration(
                      hintText: 'Enter date',
                      enabledBorder: greyBorder,
                      focusedBorder: greenBorder,
                    ),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      DateTime? pickedDate = await showPlatformDatePicker(
                        context: context,
                      );
                      if (pickedDate != null) {
                        dateController.text = "${pickedDate.toLocal()}".split(
                          ' ',
                        )[0];
                      }
                    },
                    readOnly: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height * 0.04),
                  child: SizedBox(
                    height: height * 0.065,
                    child: CustomButtons.buildButton(context, () {
                      if (nameController.text.isEmpty ||
                          amountController.text.isEmpty ||
                          selectedType == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                            backgroundColor: Colors.redAccent.shade100,
                            content: Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.exclamationmark_circle,
                                  color: Colors.white,
                                ),
                                SizedBox(width: width * 0.02),
                                Text(
                                  "Please fill all fields",
                                  style: TextStyle(
                                    fontSize: width * 0.045,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                        return;
                      }

                      final tx = Transaction(
                        id: uuid.v4(),
                        name: nameController.text,
                        amount: double.tryParse(amountController.text) ?? 0,
                        type: selectedType == "Income"
                            ? TransactionType.income
                            : TransactionType.expense,
                        date: dateController.text.isNotEmpty
                            ? DateTime.parse(dateController.text)
                            : DateTime.now(),
                      );

                      context.read<FinanceCubit>().addTransaction(tx);
                      AppDialogs.showPlatformAlertDialog(
                        context,
                        title: 'Success',
                        content: 'Transaction added successfully',
                      );

                      // reset after adding
                      nameController.clear();
                      amountController.clear();
                      dateController.clear();
                      selectedType = null;
                    }, 'Add'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
