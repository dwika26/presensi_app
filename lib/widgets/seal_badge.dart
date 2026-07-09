import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../config/app_theme.dart';

/// Widget "stempel" — elemen ciri khas aplikasi ini.
/// Dipakai di Home (lambang) & saat presensi berhasil (bukti sah).
class SealBadge extends StatelessWidget {
  final double size;
  final IconData icon;
  const SealBadge({super.key, this.size = 96, this.icon = Icons.school_rounded});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SealPainter(),
        child: Center(
          child: Icon(icon, color: Colors.white, size: size * 0.38),
        ),
      ),
    );
  }
}

class _SealPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    canvas.drawCircle(center, radius, Paint()..color = AppColors.inkNavy);

    final ringPaint = Paint()
      ..color = AppColors.brass
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.045;
    canvas.drawCircle(center, radius - ringPaint.strokeWidth, ringPaint);

    const notches = 24;
    final notchPaint = Paint()
      ..color = AppColors.brass
      ..strokeWidth = size.width * 0.02;
    for (int i = 0; i < notches; i++) {
      final angle = (2 * math.pi / notches) * i;
      final outer = Offset(
        center.dx + (radius - size.width * 0.09) * math.cos(angle),
        center.dy + (radius - size.width * 0.09) * math.sin(angle),
      );
      final inner = Offset(
        center.dx + (radius - size.width * 0.16) * math.cos(angle),
        center.dy + (radius - size.width * 0.16) * math.sin(angle),
      );
      canvas.drawLine(outer, inner, notchPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}