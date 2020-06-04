import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:perfect_first_synth/synth/synthesizer.dart';

import 'keyboard_painter.dart';

class Surface extends StatefulWidget {
  Surface({this.size, this.offset});
  final Size size;
  final Offset offset;

  @override
  _SurfaceState createState() => _SurfaceState();
}

class _SurfaceState extends State<Surface> {
  Synthesizer _synth = new Synthesizer();

  Map<int, PointerData> pointers = {};

  final int stepsCount = 10;

  final int baseFreq = 440;
  final int baseKey = 49;

  /// Intervals of Am scale in semitones
  List<int> intervals = [0, 2, 3, 5, 7, 8, 10];

  double get pixelsPerStep => widget.size.width / stepsCount;

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
    return 1 - position.dy / widget.size.height;
  }

  double cpuLoad;

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
    _updateCpuLoad();
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
    _updateCpuLoad();
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

  void _updateCpuLoad() async {
    cpuLoad = await _synth.getCpuLoad();
    setState(() {
      cpuLoad = cpuLoad;
    });
  }

  List<Widget> _getPointersText() {
    final List<Widget> pointerTexts = [];
    if (cpuLoad != null) {
      pointerTexts.add(Text('CPU load: ${cpuLoad * 100}%', style: Theme.of(context).textTheme.bodyText2,));
    }
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

class PointerData {
  PointerData({this.position, this.voice});
  Offset position;
  Voice voice;
}