import 'package:expenses_tracking_app/presentation/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/money icon.png',
              width: 340,
              height: 340,
            ),

            const Text(
              'Clear finances\nConfident future',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF438883),
                fontSize: 36,

                fontWeight: FontWeight.w700,
                height: 1.06,
                letterSpacing: -0.72,
              ),
            ),
            const SizedBox(height: 25),

            SizedBox(
              width: 358,
              height: 67,
              child: CustomButtons.buildButton(context, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUp(),
                  ), //MainNavBar SignUp
                );
              }, 'Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
