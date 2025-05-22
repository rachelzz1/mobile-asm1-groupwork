// progress_painter.dart
import 'package:flutter/material.dart';
import 'dart:math';

class ProgressPainter extends CustomPainter {
  final double progress;
  final String imagePath;

  ProgressPainter(this.progress, this.imagePath);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 - 10);
    final outerRadius = size.width / 2 * 1.2;
    final innerRadius = outerRadius * 0.95;

    //Painted gray background ring
    final Paint backgroundPaint =
        Paint()
          ..color = Colors.grey
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10.0;
    canvas.drawCircle(center, outerRadius, backgroundPaint);

    // Calculate progress angle
    double sweepAngle = 2 * pi * progress;

    // Draw a blue progress bar
    final Paint progressPaint =
        Paint()
          ..color = Color(0xFFD7E3FE)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10.0;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    // Painted yellow background circle
    final Paint innerCirclePaint = Paint()..color = Colors.yellow;
    canvas.drawCircle(center, innerRadius, innerCirclePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
