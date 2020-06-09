import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:perfect_first_synth/synth/action_receiver.dart';

import '../../recorder/recorder.dart';
import '../../recorder/state.dart';
import '../keyboard_preset.dart';

import 'keyboard_action.dart';
import 'pointer_data.dart';
import 'keyboard_painter.dart';

/// UI component emitting stream of [KeyboardAction] events.
/// Doesn't care how its actions will be interpreted, leaving it to consumers.
class Keyboard extends StatefulWidget {
  Keyboard({
    @required this.size,
    @required this.offset,
    @required this.preset,
  });
  
  final Size size;
  final Offset offset;
  final KeyboardPreset preset;

  @override
  _KeyboardState createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  _KeyboardState() {
    Recorder().stateStream.listen((newState) {
      setState(() {
        _recorderState = newState;
      });
    });
    ActionReceiver(actionStream);
  }

  double _getModulationFromPointerPosition(Offset position) {
    return 1 - position.dy / widget.size.height;
  }

  Map<int, PointerData> pointers = {};

  final int stepsCount = 8;

  RecorderState _recorderState = RecorderState.playing;

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

  List<Widget> _getPointersText() {
    final List<Widget> pointerTexts = [];
    pointers.forEach((pointerId, pointerData) {
      String step = _getNormalizedPitchOffset(pointerData.position).toStringAsFixed(2);
      String modulation = _getModulationFromPointerPosition(pointerData.position).toStringAsFixed(2);
      String pressure = pointerData.pressure.toStringAsFixed(2);
      if (step != null && modulation != null) {
        String freqText = 'Step #$step';
        String noiseText = 'Noize: $modulation';
        String gainText = 'Gain: $pressure';
        pointerTexts.add(Text(
          '$freqText, $gainText, $noiseText',
          style: Theme.of(context).textTheme.bodyText2,
        ));
      }
    });
    return pointerTexts;
  }

  String _getRecordingStatusText() {
    switch (_recorderState) {
      case RecorderState.recording:
        return 'Recording';
      case RecorderState.ready:
        return 'Ready to record';
      case RecorderState.playing:
        return '';
      default:
        throw ArgumentError('Wrong app mode (neither recording nor playing nor ready to rec)');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _playNote,
      onPointerMove: _updateNote,
      onPointerUp: _stopNote,
      child: Container(
        constraints: BoxConstraints.tight(widget.size),
        child: ClipRect(
          child: CustomPaint(
            painter: KeyboardPainter(
              pixelsPerStep: pixelsPerStep,
              mainColor: widget.preset.color,
              pointers: pointers,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getRecordingStatusText(),
                          style: Theme.of(context).textTheme.headline4,
                        )
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _getPointersText(),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
