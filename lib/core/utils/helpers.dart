import 'package:flutter/material.dart';


extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}


extension NameCapitalizer on String {
  String capitalizeName() {
    if (trim().isEmpty) return this;

    final parts = trim().split(' ');

    return parts
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}

extension MediaQueryHelper on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenAspectRatio => MediaQuery.of(this).size.aspectRatio;
}




