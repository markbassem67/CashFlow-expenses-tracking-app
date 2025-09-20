import 'package:flutter/material.dart';
import '../../core/utils/helpers.dart'; 

class ArcContainer {
  final double? height;
  final List<Color> gradientColors;

  ArcContainer({
    this.height,
    this.gradientColors = const [Color(0xFF429690), Color(0xFF2A7C76)],
  });

  Widget buildArcContainer(BuildContext context) {
    final screenWidth = context.screenWidth;
    final screenHeight = context.screenHeight;
    final containerHeight = height ?? screenHeight * 0.25;

    return SizedBox(
      width: double.infinity,
      height: containerHeight,
      child: Stack(
        children: [
          ClipPath(
            clipper: _BottomArcClipper(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          Positioned(
            //big circle - bottom left
            top: containerHeight * 0.55,
            left: -screenWidth * 0.1,
            child: Container(
              width: screenWidth * 0.25,
              height: screenWidth * 0.25,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.18 * 255).toInt()),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            //small circle - left
            top: containerHeight * 0.50,
            left: screenWidth * 0.035,
            child: Container(
              width: screenWidth * 0.15,
              height: screenWidth * 0.15,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.12 * 255).toInt()),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            //big circle - right
            top: containerHeight * 0.12,
            right: -screenWidth * 0.08,
            child: Container(
              width: screenWidth * 0.20,
              height: screenWidth * 0.20,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.15 * 255).toInt()),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: containerHeight * 0.32,
            right: screenWidth * 0.05,
            child: Container(
              width: screenWidth * 0.10,
              height: screenWidth * 0.10,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.10 * 255).toInt()),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - size.height * 0.15);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - size.height * 0.15,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
