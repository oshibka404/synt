import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:perfect_first_synth/controller/keyboard/virtual_pointer_data.dart';

import '../keyboard_preset.dart';
import '../loop_view.dart';
import 'keyboard_action.dart';
import 'keyboard_painter.dart';
import 'real_pointer_data.dart';
import 'looper_state_indicator.dart';
import 'loops_layer.dart';
import 'virtual_keyboard_action.dart';

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

  final Map<DateTime, LoopView> loopViews;

  final Function toggleLoop;

  final Function deleteRecord;

  final Map<int, VirtualKeyboardAction> virtualKeyboardActions;

  Keyboard({
    @required this.size,
    @required this.offset,
    @required this.preset,
    @required this.output,
    @required this.toggleLoop,
    this.isRecording = false,
    this.isReadyToRecord = false,
    this.loopViews,
    this.deleteRecord,
    this.virtualKeyboardActions,
  });

  @override
  _KeyboardState createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  Map<int, RealPointerData> pointers = {};
  Map<int, VirtualPointerData> get virtualPointers =>
      widget.virtualKeyboardActions.map((pointerId, action) => MapEntry(
          pointerId,
          VirtualPointerData(
              action.origin != null
                  ? _getPointerPosition(action.origin.dx, action.origin.dy)
                  : _getPointerPosition(action.position.dx, action.position.dy),
              action.preset,
              action.pressure,
              _getPointerPosition(action.position.dx, action.position.dy))));

  // TODO: use actual scale steps count
  final int stepsCount = 8;

  final double sidePadding = 24;

  var _actionStreamController = StreamController<KeyboardAction>();

  Stream<KeyboardAction> get actionStream {
    return _actionStreamController.stream;
  }

  double get pixelsPerStep =>
      (widget.size.width - sidePadding * 2) / stepsCount;

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
                    virtualPointers: virtualPointers,
                  ),
                ),
              ),
              LooperStateIndicator(
                  isRecording: widget.isRecording,
                  isInRecordingMode: widget.isReadyToRecord),
              LoopsLayer(
                size: widget.size,
                loops: widget.loopViews,
                pixelsPerStep: pixelsPerStep,
                toggleLoop: widget.toggleLoop,
                deleteRecord: widget.deleteRecord,
                sidePadding: sidePadding,
              ),
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

  Offset _getPointerPosition(double stepOffset, double modulation) {
    return Offset(sidePadding + stepOffset * pixelsPerStep,
        (1 - modulation) * widget.size.height);
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
    Map<int, RealPointerData> newPointers = {
      ...pointers,
      id: RealPointerData(
        position: position,
        pressure: pressure,
      ),
    };
    setState(() {
      pointers = newPointers;
    });
  }
}
