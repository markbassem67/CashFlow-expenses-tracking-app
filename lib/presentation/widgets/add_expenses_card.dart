import 'package:expenses_tracking_app/presentation/widgets/platform_alert_dialog.dart';
import 'package:expenses_tracking_app/presentation/widgets/platform_datepicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/transaction_model.dart';
import '../../logic/cubit/finance_cubit.dart';
import 'custom_button.dart';

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
    OutlineInputBorder greenBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF29756F), width: 1),
      borderRadius: BorderRadius.circular(8),
    );

    OutlineInputBorder greyBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      borderRadius: BorderRadius.circular(8),
    );

    return Form(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 160, 20, 0),
        child: Container(
          width: 358,
          height: 565,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 35,
                offset: Offset(0, 22),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 50,
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
                  const SizedBox(height: 20),
                  const Text(
                    'Amount',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 50,
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
                  const SizedBox(height: 20),
                  const Text(
                    'Type',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    child: DropdownButtonFormField<String>(
                      value: selectedType,
                      items: const [
                        DropdownMenuItem(
                          value: 'Expense',
                          child: Text('Expense'),
                        ),
                        DropdownMenuItem(
                          value: 'Income',
                          child: Text('Income'),
                        ),
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 50,
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
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: SizedBox(
                      height: 50,
                      child: CustomButtons.buildButton(context, () {
                        if (nameController.text.isEmpty ||
                            amountController.text.isEmpty ||
                            selectedType == null) {
                          //TODO: improve this
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                              backgroundColor: Colors.redAccent.shade100,
                              content: const Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.exclamationmark_circle,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Please fill all fields",
                                    style: TextStyle(
                                      fontSize: 18,
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
      ),
    );
  }
}
