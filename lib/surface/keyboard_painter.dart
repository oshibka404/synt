import 'package:flutter/material.dart';

class KeyboardPainter extends CustomPainter {
  KeyboardPainter({
    this.pixelsPerSemitone
  });

  final List<bool> diatonic = [true, false, true, false, true, true, false, true, false, true, false, true,];

  bool isInKey(int keyNumber) {
    return diatonic[keyNumber % 12];
  }

  bool isWhiteKey(int keyNumber) {
    return diatonic[keyNumber % 12];
  }

  bool isTonic(int keyNumber) {
    return keyNumber % 12 == 0;
  }
  
  final double pixelsPerSemitone;

  Color getKeyColor(int keyNumber) {
    if (isTonic(keyNumber)) {
      return Colors.red;
    }
    if (isInKey(keyNumber)) {
      return Colors.black;
    }
    return Colors.grey;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double keyPosition = 0;
    int keyNumber = 0;

    while (keyPosition < size.width) {
      keyPosition += pixelsPerSemitone;

      final Color keyColor = getKeyColor(keyNumber);
      canvas.drawLine(
        Offset(
          keyPosition,
          isWhiteKey(keyNumber) ? 100 : 30,
        ),
        Offset(
          keyPosition,
          isWhiteKey(keyNumber) ? size.height - 30 : size.height - 150,
        ),
        Paint()..color = keyColor
      );
      keyNumber++;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}