import 'package:flutter/material.dart';

class SiforsLogo extends StatelessWidget {
  final double size;
  const SiforsLogo({super.key, this.size = 96});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFF2C2E33), // Dark grey background circle from logo
        shape: BoxShape.circle,
      ),
      child: Center(
        child: SizedBox(
          width: size * 0.65,
          height: size * 0.65,
          child: CustomPaint(
            painter: _SiforsLogoPainter(),
          ),
        ),
      ),
    );
  }
}

class _SiforsLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Draw the yellow/gold triangle
    final path = Path();
    path.moveTo(w / 2, 0.05 * h); // Apex
    path.lineTo(0.02 * w, 0.95 * h); // Bottom-left
    path.lineTo(0.98 * w, 0.95 * h); // Bottom-right
    path.close();

    final paint = Paint()
      ..color = const Color(0xFFF1B226) // Golden yellow
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);

    // 2. Draw the cuts (negative spaces in dark grey)
    final cutPaint = Paint()
      ..color = const Color(0xFF2C2E33) // Same as background circle
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.07 // Cut width
      ..strokeCap = StrokeCap.butt; // Clean straight cut edges

    // Left Cut: Starts at bottom, goes up-right parallel to the left edge
    final leftCutPath = Path();
    leftCutPath.moveTo(0.40 * w, 0.95 * h); // Bottom edge start
    leftCutPath.lineTo(0.72 * w, 0.31 * h); // Up-right
    canvas.drawPath(leftCutPath, cutPaint);

    // Right Cut: Starts at right edge, goes down-left parallel to the left edge
    final rightCutPath = Path();
    rightCutPath.moveTo(0.79 * w, 0.58 * h); // Right edge start
    rightCutPath.lineTo(0.48 * w, 0.88 * h); // Down-left
    canvas.drawPath(rightCutPath, cutPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
