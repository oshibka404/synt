import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../recorder/recorder.dart';
import '../../recorder/state.dart';
import '../../synth/action_receiver.dart';
import '../keyboard_preset.dart';

import 'keyboard_action.dart';
import 'pointer_data.dart';
import 'keyboard_painter.dart';
import 'recorder_state_indicator.dart';

/// UI component emitting stream of [KeyboardAction] events.
/// Doesn't care how its actions will be interpreted, leaving it to consumers.
class Keyboard extends StatefulWidget {
  Keyboard({
    @required this.size,
    @required this.offset,
    @required this.preset,
    @required this.recordModeSwitchStream,
  });
  final Size size;

  final Stream<bool> recordModeSwitchStream;

  /// Screen position
  /// it's used to compute relative pointer positions since the component uses
  /// low-level [Listener] to handle touch events.
  final Offset offset;

  final KeyboardPreset preset;

  @override
  _KeyboardState createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  @override
  initState() {
    _recorder = Recorder(input: actionStream);
    _recorderStreamSubscription = _recorder.stateStream.listen((newState) {
      setState(() {
        _recorderState = newState;
      });
    });
    ActionReceiver(_recorder.output);
    this.widget.recordModeSwitchStream.listen((_isInRecordingMode) {
      setState(() {
        this._isInRecordingMode = _isInRecordingMode;
        if (!_isInRecordingMode) {
          _recorder.stopRec();
        }
      });
    });
    super.initState();
  }

  Recorder _recorder;
  StreamSubscription _recorderStreamSubscription;

  double _getModulationFromPointerPosition(Offset position) {
    return 1 - position.dy / widget.size.height;
  }

  // TODO: make immutable
  Map<int, PointerData> pointers = {};

  final int stepsCount = 8;

  RecorderState _recorderState = RecorderState.playing;
  bool _isInRecordingMode = false;

  var _actionStreamController = StreamController<KeyboardAction>();
  
  Stream<KeyboardAction> get actionStream {
    return _actionStreamController.stream;
  }

  double get pixelsPerStep => widget.size.width / stepsCount;

  /// Returns distance in scale steps (screen keys) from base key to given [position].
  double _getNormalizedPitchOffset(Offset position) {
    return position.dx / pixelsPerStep;
  }

  void _playNote(PointerEvent details) {
    Offset relativePosition = details.position - widget.offset;
    double pressure = details.pressureMax > 0 ? details.pressure : 1;
    _actionStreamController.add(
      KeyboardAction(
        voiceId: details.pointer,
        time: DateTime.now(),
        type: KeyboardActionType.start,
        stepOffset: _getNormalizedPitchOffset(relativePosition),
        pressure: pressure,
        modulation: _getModulationFromPointerPosition(relativePosition),
        preset: widget.preset,
      )
    );

    if (_isInRecordingMode && _recorderState != RecorderState.recording) {
      _recorder.startRec(relativePosition);
    }

    setState(() {
      pointers[details.pointer] = PointerData(
        position: relativePosition,
        pressure: pressure,
      );
    });
  }

  void _updateNote(PointerEvent details) {
    Offset relativePosition = details.position - widget.offset;
    double pressure = details.pressureMax > 0 ? details.pressure : 1;
    _actionStreamController.add(
      KeyboardAction(
        voiceId: details.pointer,
        time: DateTime.now(),
        type: KeyboardActionType.modify,
        stepOffset: _getNormalizedPitchOffset(relativePosition),
        pressure: pressure,
        modulation: _getModulationFromPointerPosition(relativePosition),
        preset: widget.preset,
      )
    );
    
    setState(() {
      pointers[details.pointer].position = relativePosition;
    });
  }

  void _stopNote(PointerEvent details) {
    _actionStreamController.add(
      KeyboardAction(
        voiceId: details.pointer,
        time: DateTime.now(),
        type: KeyboardActionType.stop,
      )
    );
    setState(() {
      pointers.remove(details.pointer);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _playNote,
      onPointerMove: _updateNote,
      onPointerUp: _stopNote,
      onPointerCancel: _stopNote,
      child: Container(
        constraints: BoxConstraints.tight(widget.size),
        child: ClipRect(
          child: CustomPaint(
            painter: KeyboardPainter(
              pixelsPerStep: pixelsPerStep,
              mainColor: widget.preset.color,
              pointers: pointers,
            ),
            child: RecorderStateIndicator(
              state: _recorderState,
              isInRecordingMode: _isInRecordingMode,
            ),
          ),
        )
      ),
    );
  }
  @override
  void dispose() {
    _recorderStreamSubscription.cancel();
    super.dispose();
  }
}
