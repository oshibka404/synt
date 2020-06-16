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

  Size size;

  Canvas canvas;

  Color backgroundColor = Colors.white;

  bool isTonic(int stepNumber) {
    return stepNumber % 7 == 0;
  }

  getXPositionOfKey(int keyNumber) => keyNumber * pixelsPerStep + pixelsPerStep / 2;

  void drawKey(
    int keyNumber,
    Map<int, PointerData> pointers,
  ) {
    double x = getXPositionOfKey(keyNumber);
    final Color keyColor = getKeyColor(keyNumber, pointers);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromPoints(
            Offset(x - 2, padding),
            Offset(x + 2, size.height - padding)
          ),
          Radius.circular(2)
        ),
        Paint()..color = keyColor
      );
  }
  
  final double pixelsPerStep;

  Color getKeyColor(int keyNumber, Map<int, PointerData> pointers) {
    PointerData pointer = pointers.values.firstWhere((pointerData) {
      return pointerData.position.dx ~/ pixelsPerStep == keyNumber;
    }, orElse: () => null);

    if (pointer != null) {
      return Color.lerp(mainColor, invert(mainColor), pointer.position.dy / size.height);
    }
    if (isTonic(keyNumber)) {
      return Colors.amber;
    }
    return Color.lerp(mainColor, backgroundColor, .5);
  }

  Color invert(Color color) {
    return Color(0xFFFFFFFF - (color.value % 0xFF000000));
  }

  int getClosestStepNumber(Offset position) {
    return position.dx ~/ pixelsPerStep;
  }

  double getXPositionOfClosestKey(Offset pointerPosition) {
    return pixelsPerStep * getClosestStepNumber(pointerPosition) + pixelsPerStep / 2;
  }

  @override
  void paint(Canvas canvas, Size size) {
    this.size = size;
    this.canvas = canvas;
    int keysOnScreen = size.width ~/ pixelsPerStep;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = backgroundColor
    );

    for (int key = 0; key < keysOnScreen; key++) {
      drawKey(key, pointers);
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