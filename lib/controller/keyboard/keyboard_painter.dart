import 'dart:ui';

import 'package:flutter/material.dart';

import 'pointer_data.dart';
import 'real_pointer_data.dart';
import 'virtual_pointer_data.dart';

class KeyboardPainter extends CustomPainter {
  Map<int, RealPointerData> pointers;

  final ColorSwatch<int> mainColor;

  final double padding = 30;
  final double sidePadding;

  Size size;

  Canvas canvas;

  Color backgroundColor = Colors.white;

  final double pixelsPerStep;

  final Map<int, VirtualPointerData> virtualPointers;

  // TODO: get rid of 200, 900; use semantically meaningful descriptions
  KeyboardPainter({
    @required this.pixelsPerStep,
    this.mainColor = Colors.grey,
    this.pointers,
    this.sidePadding,
    this.virtualPointers,
  });

  Color get darkMainColor => mainColor[900];

  Color get lightMainColor => mainColor[200];

  void drawKey(
    int keyNumber,
    Map<int, RealPointerData> pointers,
  ) {
    double x = getXPositionOfKey(keyNumber);
    RealPointerData pressingPointer = pointers.values.firstWhere((pointerData) {
      return getClosestStepNumber(pointerData.position) == keyNumber;
    }, orElse: () => null);

    if (pressingPointer != null) {
      drawPressedKey(x, pressingPointer);
    } else {
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromPoints(
                  Offset(x - 2, padding), Offset(x + 2, size.height - padding)),
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
  void drawPressedKey(double x, RealPointerData pressingPointer) {
    var normalizedModulation = pressingPointer.position.dy / size.height;
    var keyColor = Color.lerp(darkMainColor, lightMainColor,
        pressingPointer.position.dy / size.height);
    var paint = Paint()
      ..color = keyColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

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
    return stepNumber % 7 == 0;
  }

  void drawPointer(PointerData pointer, Color color) {
    canvas.drawCircle(
        Offset(getXPositionOfClosestKey(pointer.position), pointer.position.dy),
        pointer.pressure * 50,
        Paint()..color = color.withOpacity(.5));
  }

  void drawRealPointer(RealPointerData pointer) =>
      drawPointer(pointer, mainColor);

  void drawVirtualPointer(VirtualPointerData pointer) {
    if (pointer.preset == null) return;
    drawPointer(pointer, pointer.preset.color);
    canvas.drawLine(
        pointer.origin,
        pointer.position,
        Paint()
          ..strokeWidth = 2
          ..color = pointer.preset.color.withOpacity(.5));
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

    pointers.forEach((_, pointer) => drawRealPointer(pointer));
    virtualPointers.forEach((_, pointer) => drawVirtualPointer(pointer));
  }

  @override
  bool shouldRepaint(KeyboardPainter oldDelegate) {
    return true;
  }
}
