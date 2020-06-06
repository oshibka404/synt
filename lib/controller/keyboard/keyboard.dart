import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:perfect_first_synth/controller/keyboard_mode.dart';
import 'package:perfect_first_synth/synth/synthesizer.dart';

import 'keyboard_painter.dart';

class Keyboard extends StatefulWidget {
  Keyboard({
    this.size,
    this.offset,
    this.mode,
    this.isRecording,
  });
  
  final Size size;
  final Offset offset;
  final KeyboardMode mode;
  final bool isRecording;
  final int baseFreq = 440; // TODO: calculate [baseFreq] from [baseKey]
  final int baseKey = 49;

  @override
  _KeyboardState createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  Synthesizer _synth = new Synthesizer();

  Map<int, PointerData> pointers = {};

  final int stepsCount = 8;

  /// Intervals of Am scale in semitones
  List<int> minorScaleIntervals = [0, 2, 3, 5, 7, 8, 10];

  double get pixelsPerStep => widget.size.width / stepsCount;

  double _convertKeyNumberToFreq(double keyNumber) {
    return widget.baseFreq * pow(2, (keyNumber - widget.baseKey) / 12);
  }

  double _getKeyNumberFromPointerPosition(Offset position) {
    int stepNumber = position.dx ~/ pixelsPerStep;
    return (widget.baseKey + minorScaleIntervals[stepNumber % 7]).roundToDouble();
  }

  double _getFreqFromPointerPosition(Offset position) {
    return _convertKeyNumberToFreq(_getKeyNumberFromPointerPosition(position));
  }

  double _getModulationFromPointerPosition(Offset position) {
    return 1 - position.dy / widget.size.height;
  }

  void _playNote(PointerEvent details) async {
    Offset relativePosition = details.position - widget.offset;
    double pressure = details.pressureMax > 0 ? details.pressure : 1;
    Voice newVoice = _synth.newVoice(
      details.pointer,
      VoiceParams(
        freq: _getFreqFromPointerPosition(relativePosition),
        gain: pressure,
        noiseLevel: _getModulationFromPointerPosition(relativePosition),
        sawLevel: 1 - _getModulationFromPointerPosition(relativePosition),
      ),
    );
    setState(() {
      pointers[details.pointer] = PointerData(
        position: relativePosition,
        voice: newVoice
      );
      pointers[details.pointer].voice = newVoice;
    });
  }

  void _updateNote(PointerEvent details) {
    Offset relativePosition = details.position - widget.offset;
    double pressure = details.pressureMax > 0 ? details.pressure : 1;
    _synth.modifyVoice(
      details.pointer, 
      VoiceParams(
        freq: _getFreqFromPointerPosition(relativePosition),
        gain: pressure,
        noiseLevel: _getModulationFromPointerPosition(relativePosition),
        sawLevel: 1 - _getModulationFromPointerPosition(relativePosition),
      ),
    );
    setState(() {
      pointers[details.pointer].voice = pointers[details.pointer].voice;
      pointers[details.pointer].position = relativePosition;
    });
  }

  void _stopNote(PointerEvent details) {
    _synth.stopVoice(details.pointer);
    setState(() {
      pointers.remove(details.pointer);
    });
  }

  List<Widget> _getPointersText() {
    final List<Widget> pointerTexts = [];
    pointers.forEach((pointerId, pointerData) {
      if (pointerData.voice.params['freq'] != null && pointerData.voice.params['gain'] != null) {
        pointerTexts.add(Text(
          '${pointerData.voice.params['freq'].toStringAsFixed(2)} Hz, ${pointerData.voice.params['gain'].toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.bodyText2,
        ));
      }
    });
    return pointerTexts;
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
              mainColor: widget.mode.color,
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
                          widget.isRecording ? 'Rec' : '',
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

class PointerData {
  PointerData({this.position, this.voice});
  Offset position;
  Voice voice;
}