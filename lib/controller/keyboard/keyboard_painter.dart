import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:synt/controller/keyboard/triggered_key_data.dart';

import 'pointer_data.dart';
import 'presets/keyboard_colors.dart';
import 'presets/keyboard_preset.dart';

class KeyboardPainter extends CustomPainter {
  Map<int, PointerData> pointers;

  final KeyboardColors mainColor;

  final double padding = 30;
  final double sidePadding;
  final int scaleLength;
  final Map<int, TriggeredKeyData> triggeredKeys;

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
    this.triggeredKeys,
  });

  Color get darkMainColor => mainColor.main;
  Color get lightMainColor => mainColor.light;

  void drawKey(int keyNumber) {
    double x = getXPositionOfKey(keyNumber);

    var strokeWidth = getKeyStrokeWidth(keyNumber);
    canvas.drawRect(
        Rect.fromPoints(Offset(x - strokeWidth / 2, padding),
            Offset(x + strokeWidth / 2, size.height - padding)),
        Paint()..color = getKeyColor(keyNumber));
  }

  double getKeyStrokeWidth(int keyNumber) {
    return isTonic(keyNumber) ? lineThickness * 1.5 : lineThickness;
  }

  Color getKeyColor(int keyNumber, {KeyboardPreset preset}) {
    PointerData pressingPointer = pointers.values.firstWhere((pointerData) {
      return getClosestStepNumber(pointerData.position) == keyNumber;
    }, orElse: () => null);

    if (pressingPointer != null) {
      return mainColor;
    }
    return Colors.black;
  }

  void drawTriggeredKey(TriggeredKeyData trigKey) {
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineThickness / 2
      ..color = trigKey.preset.color.heavy;

    var waves = 1 + trigKey.preset.baseKey ~/ 12;

    var path = getWavePath(
        getXPositionOfKey(trigKey.keyNumber), waves, trigKey.velocity);
    canvas.drawPath(path, paint);
  }

  int getClosestStepNumber(Offset position) {
    return (position.dx - sidePadding) ~/ pixelsPerStep;
  }

  /// returns [Path] of the wave for pressed key.
  Path getWavePath(double x, int waves, double velocity) {
    var path = Path();
    double amplitude = pixelsPerStep / 4 * velocity + 3;
    var availableHeight = size.height - (2 * padding);
    var waveLength = availableHeight / waves;

    // full cycle is 1, peaks on .25 and .75
    path.moveTo(x, padding);

    for (int i = 0; i < waves; i++) {
      double waveStartY = padding + waveLength * i;
      path.quadraticBezierTo((x + amplitude), waveStartY + (waveLength / 4), x,
          waveStartY + (waveLength / 2));
      path.quadraticBezierTo(
          (x - amplitude),
          waveStartY + (waveLength / 2 + (waveLength / 4)),
          x,
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

    triggeredKeys.forEach((key, trigData) {
      drawTriggeredKey(trigData);
    });

    for (int key = 0; key < keysOnScreen; key++) {
      // don't draw keys over already drawn active trigs
      drawKey(key);
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
