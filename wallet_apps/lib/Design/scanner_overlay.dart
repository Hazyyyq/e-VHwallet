import 'package:flutter/material.dart';

class ScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.5);

    // Creates the "dimmed" background
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset(size.width / 2, size.height / 2),
                width: 250,
                height: 250,
              ),
              const Radius.circular(20),
            ),
          )
          ..close(),
      ),
      paint,
    );

    // Draw the bright corners
    final borderPaint = Paint()
      ..color = const Color(0xFFE4FF78) 
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final path = Path();
    double offset = 20.0;
    double centerW = size.width / 2;
    double centerH = size.height / 2;
    Rect rect = Rect.fromCenter(
      center: Offset(centerW, centerH),
      width: 250,
      height: 250,
    );

    // Top Left
    path.moveTo(rect.left, rect.top + offset);
    path.lineTo(rect.left, rect.top);
    path.lineTo(rect.left + offset, rect.top);
    // Top Right
    path.moveTo(rect.right - offset, rect.top);
    path.lineTo(rect.right, rect.top);
    path.lineTo(rect.right, rect.top + offset);
    // Bottom Right
    path.moveTo(rect.right, rect.bottom - offset);
    path.lineTo(rect.right, rect.bottom);
    path.lineTo(rect.right - offset, rect.bottom);
    // Bottom Left
    path.moveTo(rect.left + offset, rect.bottom);
    path.lineTo(rect.left, rect.bottom);
    path.lineTo(rect.left, rect.bottom - offset);

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}