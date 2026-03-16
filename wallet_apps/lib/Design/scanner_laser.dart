import 'package:flutter/material.dart';

class ScannerLaser extends StatelessWidget {
  final Animation<double> animation;
  const ScannerLaser({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: (MediaQuery.of(context).size.height / 2 - 125) + (animation.value * 250),
      left: MediaQuery.of(context).size.width / 2 - 110,
      child: Container(
        width: 220,
        height: 2,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE4FF78).withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
          gradient: const LinearGradient(
            colors: [Colors.transparent, Color(0xFFE4FF78), Colors.transparent],
          ),
        ),
      ),
    );
  }
}