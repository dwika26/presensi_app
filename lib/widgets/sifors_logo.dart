import 'package:flutter/material.dart';

class SiforsLogo extends StatelessWidget {
  final double size;
  const SiforsLogo({super.key, this.size = 96});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        'assets/images/logo.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
