import 'dart:ui';
import 'package:expenses_tracking_app/core/utils/helpers.dart';
import 'package:expenses_tracking_app/presentation/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('firstLaunch') ?? true;

    if (isFirstLaunch) {
      await prefs.setBool('firstLaunch', false);
    }

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (context, animation, secondaryAnimation) =>
              isFirstLaunch ? const OnboardingScreen() : const MainNavBar(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 20.0 * animation.value,
                    sigmaY: 20.0 * animation.value,
                  ),
                  child: Container(color: Colors.black.withAlpha(0)),
                ),
                FadeTransition(opacity: animation, child: child),
              ],
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
          body: Center(
            child: Text(
              'CashFlow',
              style: TextStyle(
                color: Colors.white,
                fontSize: context.screenWidth * 0.08,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
