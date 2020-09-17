import 'dart:ui';

import 'package:flutter/material.dart';

import 'pointer_data.dart';
import 'presets/keyboard_colors.dart';

class KeyboardPainter extends CustomPainter {
  Map<int, PointerData> pointers;

  final KeyboardColors mainColor;

  final double padding = 30;
  final double sidePadding;
  final int scaleLength;

  Size size;

  Canvas canvas;

  Color backgroundColor = Colors.white;

  final double pixelsPerStep;
  double lineThickness = 3;
  KeyboardPainter({
    @required this.pixelsPerStep,
    this.mainColor,
    this.pointers,
    this.sidePadding,
    this.scaleLength,
  });

  Color get darkMainColor => mainColor['main'];

  Color get lightMainColor => mainColor['light'];

  void drawKey(
    int keyNumber,
    Map<int, PointerData> pointers,
  ) {
    double x = getXPositionOfKey(keyNumber);
    PointerData pressingPointer = pointers.values.firstWhere((pointerData) {
      return getClosestStepNumber(pointerData.position) == keyNumber;
    }, orElse: () => null);

    if (pressingPointer != null) {
      drawPressedKey(x, pressingPointer);
    } else {
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromPoints(Offset(x - lineThickness / 2, padding),
                  Offset(x + lineThickness / 2, size.height - padding)),
              Radius.circular(2)),
          Paint()
            ..shader = LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: getKeyColors(keyNumber))
                .createShader(Rect.fromLTRB(0, 0, size.width, size.height)));
    }
  }

  // TODO: Isolate drawing primitives
  void drawPressedKey(double x, PointerData pressingPointer) {
    var normalizedModulation = pressingPointer.position.dy / size.height;
    var keyColor = Color.lerp(darkMainColor, lightMainColor,
        pressingPointer.position.dy / size.height);
    var paint = Paint()
      ..color = keyColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineThickness;

    var path = getWavePath(x, 3, 1 - normalizedModulation);
    canvas.drawPath(path, paint);
  }

  int getClosestStepNumber(Offset position) {
    return (position.dx - sidePadding) ~/ pixelsPerStep;
  }

  /// Returns colors of a gradient to paint a key of a given [keyNumber]
  ///
  /// (From top to bottom)
  List<Color> getKeyColors(int keyNumber) {
    if (isTonic(keyNumber)) {
      return [
        darkMainColor,
        lightMainColor,
      ];
    }
    return [
      Colors.black,
      Colors.black,
    ];
  }

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
          (x + (amplitude * (1 - sharpness))),
          waveStartY + (waveLength / 4 * (1 - sharpness)),
          x - amplitude * sharpness,
          waveStartY + (waveLength / 2 * (1 - sharpness)));
      path.quadraticBezierTo(
          (x - (amplitude * (1 - sharpness))),
          waveStartY + (waveLength / 2 + (waveLength / 4 * (1 - sharpness))),
          x + amplitude * sharpness,
          waveStartY + waveLength);
    }
    return path;
  }

  double getXPositionOfClosestKey(Offset pointerPosition) =>
      getXPositionOfKey(getClosestStepNumber(pointerPosition));

  double getXPositionOfKey(int keyNumber) =>
      sidePadding + (keyNumber * pixelsPerStep) + (pixelsPerStep / 2);

  bool isTonic(int stepNumber) {
    return stepNumber % scaleLength == 0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    this.size = size;
    this.canvas = canvas;
    int keysOnScreen = (size.width - 2 * sidePadding) ~/ pixelsPerStep;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = backgroundColor);

    for (int key = 0; key < keysOnScreen; key++) {
      drawKey(key, pointers);
    }

    pointers.forEach((_, pointer) {
      canvas.drawCircle(
          Offset(
              getXPositionOfClosestKey(pointer.position), pointer.position.dy),
          pointer.pressure * 50,
          Paint()..color = mainColor.withOpacity(.5));
    });
  }

  @override
  bool shouldRepaint(KeyboardPainter oldDelegate) {
    return true;
  }
}
