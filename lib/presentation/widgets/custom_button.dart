import 'package:flutter/material.dart';

class CustomButtons {
  static Widget buildButton(BuildContext context,VoidCallback? onPressedAction,String buttonText) {
    return ElevatedButton(
      onPressed: onPressedAction,
      style: ElevatedButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        elevation: 6,
        backgroundColor: Colors.transparent,
        shadowColor: const Color(0xFF3E7C77),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment(0.46, -0.17),
            end: Alignment(0.46, 1.23),
            colors: [Color(0xFF68AEA9), Color(0xFF3E8681)],
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Container(
          alignment: Alignment.center,
          child:  Text(
            buttonText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.36,
            ),
          ),
        ),
      ),
    );
  }
}
