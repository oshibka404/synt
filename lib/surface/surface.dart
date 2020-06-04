import 'dart:math';

import 'package:flutter/material.dart';
import 'package:perfect_first_synth/synth/synthesizer.dart';

import 'keyboard_painter.dart';

class Surface extends StatefulWidget {
  Surface({Key key}) : super(key: key);

  @override
  _SurfaceState createState() => _SurfaceState();
}

class PointerData {
  PointerData({this.position, this.voice});
  Offset position;
  Voice voice;
}

class _SurfaceState extends State<Surface> {
  Synthesizer _synth = new Synthesizer();

  Map<int, PointerData> pointers = {};

  final int stepsCount = 10;

  Size size = new Size.square(0);

  final int baseFreq = 440;
  final int baseKey = 49;

  /// Intervals of Am scale in semitones
  List<int> intervals = [0, 2, 3, 5, 7, 8, 10];

  double get pixelsPerStep => size.width / stepsCount;

  double _convertKeyNumberToFreq(double keyNumber) {
    return baseFreq * pow(2, (keyNumber - baseKey) / 12);
  }

  double _getKeyNumberFromPointerPosition(Offset position) {
    int stepNumber = position.dx ~/ pixelsPerStep;
    return (baseKey + intervals[stepNumber % 7]).roundToDouble();
  }

  double _getFreqFromPointerPosition(Offset position) {
    return _convertKeyNumberToFreq(_getKeyNumberFromPointerPosition(position));
  }

  double _getModulationFromPointerPosition(Offset position) {
    return 1 - position.dy / size.height;
  }

  void _playNote(PointerEvent details) async {
    Voice newVoice = _synth.newVoice(
      details.pointer,
      freq: _getFreqFromPointerPosition(details.position),
      gain: _getModulationFromPointerPosition(details.position),
    );
    setState(() {
      pointers[details.pointer] = PointerData(
        position: details.position,
        voice: newVoice
      );
      pointers[details.pointer].voice = newVoice;
    });
  }

  void _updateNote(PointerEvent details) {
    _synth.modifyVoice(
      details.pointer, 
      freq: _getFreqFromPointerPosition(details.position),
      gain: _getModulationFromPointerPosition(details.position),
    );
    setState(() {
      pointers[details.pointer].voice = pointers[details.pointer].voice;
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
    setState(() {
      size = MediaQuery.of(context).size;
    });
    return Listener(
      onPointerDown: _playNote,
      onPointerMove: _updateNote,
      onPointerUp: _stopNote,
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: ClipRect(
          child: CustomPaint(
            painter: KeyboardPainter(
              pixelsPerStep: pixelsPerStep
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Column(
                children: _getPointersText(),
              ),
            ),
          ),
        )
      ),
    );
  }
}
