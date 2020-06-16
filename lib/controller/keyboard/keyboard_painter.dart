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

  final double padding = 30;

  bool isTonic(int stepNumber) {
    return stepNumber % 7 == 0;
  }

  getXPositionOfKey(int keyNumber) => keyNumber * pixelsPerStep + pixelsPerStep / 2;

  void drawKey({
    Canvas canvas,
    int keyNumber,
    Map<int, PointerData> pointers,
    Iterable<int> pressedKeys,
    double length,
  }) {
    double x = getXPositionOfKey(keyNumber);
    final Color keyColor = getKeyColor(keyNumber, pressedKeys);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromPoints(
            Offset(x - 2, padding),
            Offset(x + 2, length + padding)
          ),
          Radius.circular(2)
        ),
        Paint()..color = keyColor
      );
  }
  
  final double pixelsPerStep;

  Color getKeyColor(int keyNumber, Iterable<int> pressedKeys) {
    if (pressedKeys.any((pressedKey) => pressedKey == keyNumber)) {
      return Colors.deepPurple;
    }
    if (isTonic(keyNumber)) {
      return Colors.amber;
    }
    return mainColor;
  }

  int getClosestStepNumber(Offset position) {
    return position.dx ~/ pixelsPerStep;
  }

  double getXPositionOfClosestKey(Offset pointerPosition) {
    return pixelsPerStep * getClosestStepNumber(pointerPosition) + pixelsPerStep / 2;
  }

  @override
  void paint(Canvas canvas, Size size) {
    int keysOnScreen = size.width ~/ pixelsPerStep;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white
    );

    Iterable<int> pressedKeys = pointers.values.map((pointerData) {
      return getClosestStepNumber(pointerData.position);
    });

    for (int key = 0; key < keysOnScreen; key++) {
      drawKey(
        canvas: canvas,
        keyNumber: key,
        pointers: pointers,
        pressedKeys: pressedKeys,
        length: size.height - (padding * 2),
      );
    }
    
    pointers.forEach((_, pointer) {
      canvas.drawCircle(
        Offset(getXPositionOfClosestKey(pointer.position), pointer.position.dy),
        pointer.pressure * 50,
        Paint()..color = mainColor.withOpacity(.5)
      );
    });
  }

  @override
  bool shouldRepaint(KeyboardPainter oldDelegate) {
    return true; // TODO: check pointers and mainColor (to do it make pointers immutable)
  }
}