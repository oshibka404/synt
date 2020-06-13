import 'package:flutter/material.dart';

import 'pointer_data.dart';

class KeyboardPainter extends CustomPainter {
  KeyboardPainter({
    @required this.pixelsPerStep,
    this.mainColor = Colors.black,
    this.pointers,
  });

  Map<int, PointerData> pointers;

  final Color mainColor;

  bool isTonic(int stepNumber) {
    return stepNumber % 7 == 0;
  }
  
  final double pixelsPerStep;

  Color getKeyColor(int keyNumber) {
    if (isTonic(keyNumber)) {
      return Colors.amber;
    }
    return mainColor;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double keyPosition = pixelsPerStep / 2;
    int keyNumber = 0;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white
    );

    while (keyPosition < size.width) {
      final Color keyColor = getKeyColor(keyNumber);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromPoints(
            Offset(keyPosition - 2, 30),
            Offset(keyPosition + 2, size.height - 30)
          ),
          Radius.circular(2)
        ),
        Paint()..color = keyColor
      );
      keyPosition += pixelsPerStep;
      keyNumber++;
    }
    
    pointers.forEach((_, pointer) {
      canvas.drawCircle(
        pointer.position,
        pointer.pressure * 50,
        Paint()..color = mainColor.withOpacity(.5)
      );
    });
  }

  @override
  bool shouldRepaint(KeyboardPainter oldDelegate) {
    return true;
  }
}