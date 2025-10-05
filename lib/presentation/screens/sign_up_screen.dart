import 'package:currency_picker/currency_picker.dart';
import 'package:expenses_tracking_app/core/utils/helpers.dart';
import 'package:expenses_tracking_app/logic/cubit/finance_cubit.dart';
import 'package:expenses_tracking_app/presentation/widgets/custom_button.dart';
import 'package:expenses_tracking_app/presentation/widgets/nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  final TextEditingController nameController = TextEditingController();
  String? selectedCurrency = "USD";

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderSide: BorderSide(color: color, width: 1.2),
    borderRadius: BorderRadius.circular(12),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF429690), Color(0xFF2A7C76)],
            ),
          ),
        ),

        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                width: 360,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x26000000),
                      blurRadius: 30,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name Field
                    const Text(
                      "Your Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: nameController,
                      cursorColor: const Color(0xFF29756F),
                      decoration: InputDecoration(
                        hintText: "Enter your full name",
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        enabledBorder: _border(Colors.grey.shade300),
                        focusedBorder: _border(const Color(0xFF29756F)),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Currency Picker
                    const Text(
                      "Preferred Currency",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        showCurrencyPicker(
                          context: context,
                          onSelect: (Currency currency) {
                            selectedCurrency = currency.symbol;
                            // force rebuild
                            (context as Element).markNeedsBuild();
                          },
                        );
                      },
                      child: Container(
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
                              selectedCurrency ?? "Select currency",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF2A7C76),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: CustomButtons.buildButton(context, () {
                        if (nameController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.redAccent.shade100,
                              content: const Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.exclamationmark_circle,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Please fill in your name",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                          return;
                        } else {
                          final name = nameController.text
                              .trim()
                              .capitalizeName();

                          context.read<FinanceCubit>().setUsername(name);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainNavBar(),
                            ),
                          );
                        }
                      }, 'Get Started'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
