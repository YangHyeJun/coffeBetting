import 'package:flutter/cupertino.dart';

class TouchPointsPainter extends CustomPainter {
  final Map<int, Offset> touchPoints;
  final Offset? expandingPoint;
  final Color expandingColor;
  final double animationValue;
  final List<Color> colors;

  TouchPointsPainter({
    required this.touchPoints,
    required this.expandingPoint,
    required this.expandingColor,
    required this.animationValue,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    touchPoints.forEach((pointerId, position) {
      final paint = Paint()..color = colors[pointerId % colors.length];
      canvas.drawCircle(position, 60, paint);
    });

    if (expandingPoint != null) {
      final paint = Paint()..color = expandingColor.withOpacity(animationValue);
      double radius = size.longestSide * animationValue;
      canvas.drawCircle(expandingPoint!, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}