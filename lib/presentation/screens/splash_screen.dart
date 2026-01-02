import 'dart:ui';
import 'package:expenses_tracking_app/logic/cubit/finance_cubit.dart';
import 'package:expenses_tracking_app/presentation/screens/biometrics_screen.dart';
import 'package:expenses_tracking_app/presentation/widgets/nav_bar.dart';
import 'package:expenses_tracking_app/presentation/widgets/splash_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final isFirstLaunch = await context.read<FinanceCubit>().isFirstLaunch();
    final isBiometricsOn = await context
        .read<FinanceCubit>()
        .loadBiometricsSetting();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (context, animation, secondaryAnimation) => isFirstLaunch
              ? const OnboardingScreen()
              : isBiometricsOn
              ? const BiometricsScreen()
              : const MainNavBar(),

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
    return const SplashUi();
  }
}
