import 'package:expenses_tracking_app/core/utils/helpers.dart';
import 'package:expenses_tracking_app/presentation/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = context.screenWidth;
    final height = context.screenHeight;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/money icon.png',
              width: width * 0.65,
              height: height * 0.3,
            ),

            Text(
              'Clear finances\nConfident future',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF438883),
                fontSize: width * 0.08,

                fontWeight: FontWeight.w700,
                height: height * 0.00115,
                letterSpacing: -width * 0.0004,
              ),
            ),
            SizedBox(height: height * 0.035),
            SizedBox(
              width: width * 0.8,
              height: height * 0.08,
              child: CustomButtons.buildButton(context, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignUp()),
                );
              }, 'Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
