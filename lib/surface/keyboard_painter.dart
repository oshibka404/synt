import 'package:flutter/material.dart';

class KeyboardPainter extends CustomPainter {
  KeyboardPainter({
    this.pixelsPerStep
  });

  bool isTonic(int stepNumber) {
    return stepNumber % 7 == 0;
  }
  
  final double pixelsPerStep;

  Color getKeyColor(int keyNumber) {
    if (isTonic(keyNumber)) {
      return Colors.red;
    }
    return Colors.black;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double keyPosition = pixelsPerStep / 2;
    int keyNumber = 0;

    while (keyPosition < size.width) {
      final Color keyColor = getKeyColor(keyNumber);
      canvas.drawLine(
        Offset(keyPosition, 30),
        Offset(keyPosition, size.height - 30),
        Paint()..color = keyColor
      );
      keyPosition += pixelsPerStep;
      keyNumber++;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}