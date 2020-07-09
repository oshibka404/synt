import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../keyboard_preset.dart';
import '../loop_view.dart';
import 'keyboard_action.dart';
import 'keyboard_painter.dart';
import 'pointer_data.dart';
import 'looper_state_indicator.dart';

/// UI component emitting stream of [KeyboardAction] events.
///
/// Doesn't care how its actions will be interpreted, leaving it to consumers.
class Keyboard extends StatefulWidget {
  final Size size;

  /// Screen position
  ///
  /// it's used to compute relative pointer positions since the component uses
  /// low-level [Listener] to handle touch events.
  final Offset offset;

  /// Where this [Keyboard] will send its commands.
  final StreamConsumer output;

  final KeyboardPreset preset;

  final bool isRecording;

  final bool isReadyToRecord;

  final int scaleLength;

  Keyboard({
    @required this.size,
    @required this.offset,
    @required this.preset,
    @required this.output,
    this.scaleLength = 7,
    this.isRecording = false,
    this.isReadyToRecord = false,
  });

  @override
  _KeyboardState createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  Map<int, PointerData> pointers = {};

  final int keysOnScreen = 8;

  final double sidePadding = 24;

  var _actionStreamController = StreamController<KeyboardAction>();

  Stream<KeyboardAction> get actionStream {
    return _actionStreamController.stream;
  }

  double get pixelsPerStep =>
      (widget.size.width - sidePadding * 2) / keysOnScreen;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _addPointer,
      onPointerMove: _modifyPointer,
      onPointerUp: _removePointer,
      onPointerCancel: _removePointer,
      child: Container(
          constraints: BoxConstraints.tight(widget.size),
          child: Stack(
            children: [
              ClipRect(
                child: CustomPaint(
                  size: widget.size,
                  painter: KeyboardPainter(
                    sidePadding: sidePadding,
                    pixelsPerStep: pixelsPerStep,
                    mainColor: widget.preset.color,
                    pointers: pointers,
                    scaleLength: widget.scaleLength,
                  ),
                ),
              ),
              LooperStateIndicator(
                  isRecording: widget.isRecording,
                  isInRecordingMode: widget.isReadyToRecord),
            ],
          )),
    );
  }

  @override
  void dispose() {
    widget.output.close();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    widget.output.addStream(actionStream);
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

  double _getModulationFromPointerPosition(Offset position) {
    return 1 - position.dy / widget.size.height;
  }

  double _getPressure(PointerEvent details) {
    return details.pressureMax > 0 ? details.pressure : 1;
  }

  Offset _getRelativePosition(PointerEvent details) {
    return details.position - widget.offset;
  }

  /// Returns distance in scale steps (screen keys) from base key to given [position].
  double _getStepOffset(Offset position) {
    return (position.dx - sidePadding) / pixelsPerStep;
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
      _updatePointer(details.pointer, relativePosition, pressure);
    });
  }

  void _removePointer(PointerEvent details) {
    _actionStreamController.add(KeyboardAction.release(details.pointer));
    setState(() {
      pointers.remove(details.pointer);
    });
  }

  void _updatePointer(int id, Offset position, double pressure) {
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
}
