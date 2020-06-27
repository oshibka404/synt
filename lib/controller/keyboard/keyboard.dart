import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../keyboard_preset.dart';

import 'keyboard_action.dart';
import 'pointer_data.dart';
import 'keyboard_painter.dart';

/// UI component emitting stream of [KeyboardAction] events.
///
/// Doesn't care how its actions will be interpreted, leaving it to consumers.
class Keyboard extends StatefulWidget {
  Keyboard({
    @required this.size,
    @required this.offset,
    @required this.preset,
    @required this.output,
  });
  final Size size;

  /// Screen position
  ///
  /// it's used to compute relative pointer positions since the component uses
  /// low-level [Listener] to handle touch events.
  final Offset offset;

  /// Where this [Keyboard] will send its commands.
  final StreamConsumer output;

  final KeyboardPreset preset;

  @override
  _KeyboardState createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  double _getModulationFromPointerPosition(Offset position) {
    return 1 - position.dy / widget.size.height;
  }

  @override
  initState() {
    super.initState();
    widget.output.addStream(actionStream);
  }

  Map<int, PointerData> pointers = {};

  final int stepsCount = 8;

  var _actionStreamController = StreamController<KeyboardAction>();

  Stream<KeyboardAction> get actionStream {
    return _actionStreamController.stream;
  }

  double get pixelsPerStep => widget.size.width / stepsCount;

  /// Returns distance in scale steps (screen keys) from base key to given [position].
  double _getStepOffset(Offset position) {
    return position.dx / pixelsPerStep;
  }

  _getPressure(PointerEvent details) {
    return details.pressureMax > 0 ? details.pressure : 1;
  }

  _getRelativePosition(PointerEvent details) {
    return details.position - widget.offset;
  }

  _updatePointer(int id, Offset position, double pressure) {
    Map<int, PointerData> newPointers = {
      ...pointers,
      id: PointerData(
        position: position,
        pressure: pressure,
      ),
    };
    setState(() {
      pointers = newPointers;
    });
  }

  void _addPointer(PointerEvent details) {
    Offset relativePosition = _getRelativePosition(details);
    double pressure = _getPressure(details);

    _actionStreamController.add(KeyboardAction.press(
      details.pointer,
      stepOffset: _getStepOffset(relativePosition),
      pressure: pressure,
      modulation: _getModulationFromPointerPosition(relativePosition),
    ));

    _updatePointer(details.pointer, relativePosition, pressure);
  }

  void _modifyPointer(PointerEvent details) {
    Offset relativePosition = details.position - widget.offset;
    double pressure = _getPressure(details);
    _actionStreamController.add(KeyboardAction.press(
      details.pointer,
      stepOffset: _getStepOffset(relativePosition),
      pressure: pressure,
      modulation: _getModulationFromPointerPosition(relativePosition),
    ));

    setState(() {
      pointers[details.pointer].position = relativePosition;
    });
  }

  void _removePointer(PointerEvent details) {
    _actionStreamController.add(KeyboardAction.release(details.pointer));
    setState(() {
      pointers.remove(details.pointer);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _addPointer,
      onPointerMove: _modifyPointer,
      onPointerUp: _removePointer,
      onPointerCancel: _removePointer,
      child: Container(
          constraints: BoxConstraints.tight(widget.size),
          child: ClipRect(
            child: CustomPaint(
              painter: KeyboardPainter(
                pixelsPerStep: pixelsPerStep,
                mainColor: widget.preset.color,
                pointers: pointers,
              ),
            ),
          )),
    );
  }

  @override
  void dispose() {
    widget.output.close();
    super.dispose();
  }
}
