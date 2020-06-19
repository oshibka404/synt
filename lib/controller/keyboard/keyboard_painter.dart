import 'dart:ui';

import 'package:flutter/material.dart';

import 'pointer_data.dart';

class KeyboardPainter extends CustomPainter {
  KeyboardPainter({
    @required this.pixelsPerStep,
    this.mainColor = Colors.grey,
    this.pointers,
  });

  Map<int, PointerData> pointers;

  final MaterialColor mainColor;

  final double padding = 30;

  Size size;

  Canvas canvas;

  Color backgroundColor = Colors.white;
  Color get lightMainColor => mainColor[200];
  Color get darkMainColor => mainColor[900];

  bool isTonic(int stepNumber) {
    return stepNumber % 7 == 0;
  }

  getXPositionOfKey(int keyNumber) => keyNumber * pixelsPerStep + pixelsPerStep / 2;

  // TODO: Isolate drawing primitives
  /// returns [Path] of the wave for pressed key
  ///
  /// From smooth sine-ish (when) [sharpness] = 0
  /// to saw (when 1)
  Path getWavePath(double x, int waves, double sharpness) {
    var path = Path();
    double amplitude = pixelsPerStep / 4;
    var availableHeight = size.height - (2 * padding);
    var waveLength = availableHeight / waves;

    // full cycle is 1, peaks on .25 and .75
    path.moveTo(x + (amplitude * sharpness), padding);

    for (int i = 0; i < waves; i++) {
      double waveStartY = padding + waveLength * i;
      path.quadraticBezierTo(
        (x + (amplitude * (1 - sharpness))), waveStartY + (waveLength / 4 * (1 - sharpness)),
        x - amplitude * sharpness, waveStartY + (waveLength / 2 * (1 - sharpness))
      );
      path.quadraticBezierTo(
        (x - (amplitude * (1 - sharpness))), waveStartY + (waveLength / 2 + (waveLength / 4 * (1 - sharpness))),
        x + amplitude * sharpness, waveStartY + waveLength
      );
    }
    return path;
  }

  void drawPressedKey(double x, PointerData pressingPointer) {
    var normalizedModulation = pressingPointer.position.dy / size.height;
    var keyColor = Color.lerp(
      darkMainColor,
      lightMainColor,
      pressingPointer.position.dy / size.height
    );
    var paint = Paint()
      ..color = keyColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    
    var path = getWavePath(x, 3, 1 - normalizedModulation);
    canvas.drawPath(path, paint);
  }

  void drawKey(
    int keyNumber,
    Map<int, PointerData> pointers,
  ) {
    double x = getXPositionOfKey(keyNumber);
    PointerData pressingPointer = pointers.values.firstWhere((pointerData) {
      return pointerData.position.dx ~/ pixelsPerStep == keyNumber;
    }, orElse: () => null);
    
    if (pressingPointer != null) {
      drawPressedKey(x, pressingPointer);
    } else {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromPoints(
            Offset(x - 2, padding),
            Offset(x + 2, size.height - padding)
          ),
          Radius.circular(2)
        ),
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: getKeyColors(keyNumber)
          ).createShader(Rect.fromLTRB(0, 0, size.width, size.height))
      );
    }
  }
  
  final double pixelsPerStep;

  /// Returns colors of a gradient to paint a key of a given [keyNumber]
  /// 
  /// (From top to bottom)
  List<Color> getKeyColors(int keyNumber) {
    if (isTonic(keyNumber)) {
      return [
        Colors.amber[900],
        Colors.amber[200],
      ];
    }
    return [
      darkMainColor,
      lightMainColor,
    ];
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