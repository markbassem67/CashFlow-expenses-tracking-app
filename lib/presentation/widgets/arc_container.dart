import 'package:flutter/material.dart';

class ArcContainer {
  final double height;
  final List<Color> gradientColors;

  ArcContainer({
    this.height = 200,
    this.gradientColors = const [Color(0xFF429690), Color(0xFF2A7C76)],
  });

  Widget buildArcContainer() {
    return SizedBox(
      width: double.infinity,
      height: height,
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
          // Overlapping white circles
          Positioned(
            top: 150,
            left: -40,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.18 * 255).toInt()),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 135,
            left: 15,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.12 * 255).toInt()),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.15 * 255).toInt()),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 70,
            right: 20,
            child: Container(
              width: 40,
              height: 40,
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
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
