import 'dart:math';

import 'package:flutter/material.dart';
import 'package:perfect_first_synth/synth/synthesizer.dart';

import 'keyboard_painter.dart';

class Surface extends StatefulWidget {
  Surface({Key key}) : super(key: key);

  @override
  _SurfaceState createState() => _SurfaceState();
}

class _SurfaceState extends State<Surface> {
  Synthesizer _synth = new Synthesizer();

  Map<int, Voice> _voices = {};

  final double pixelsPerSemitone = 30;

  double width;

  final int baseFreq = 440;

  double convertSemitonesToFreq(double semitones) {
    return baseFreq * pow(2, semitones.round() / 12);
  }

  double _getFreqFromPointerPosition(Offset position) {
    return convertSemitonesToFreq(position.dx / pixelsPerSemitone);
  }

  double _getGainFromPointerPosition(Offset position) {
    return 5 - position.dy / 100;
  }

  void _playNote(PointerEvent details) async {
    Voice newVoice = _synth.newVoice(
      details.pointer,
      freq: _getFreqFromPointerPosition(details.position),
      gain: _getGainFromPointerPosition(details.position),
    );
    setState(() {
      _voices[details.pointer] = newVoice;
    });
  }

  void _updateNote(PointerEvent details) {
    _synth.modifyVoice(
      details.pointer, 
      freq: _getFreqFromPointerPosition(details.position),
      gain: _getGainFromPointerPosition(details.position),
    );
    setState(() {
      _voices[details.pointer] = _voices[details.pointer];
    });
  }

  void _stopNote(PointerEvent details) {
    _synth.stopVoice(details.pointer);
    setState(() {
      _voices.remove(details.pointer);
    });
  }

  List<Widget> _getPointersText() {
    final List<Widget> pointerTexts = [];
    _voices.forEach((pointer, voice) {
      if (voice.params['freq'] != null && voice.params['gain'] != null) {
        pointerTexts.add(Text(
          '${voice.params['freq'].toStringAsFixed(2)} Hz, ${voice.params['gain'].toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.bodyText2,
        ));
      }
    });
    return pointerTexts;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      width = MediaQuery.of(context).size.width;
    });
    return Listener(
      onPointerDown: _playNote,
      onPointerMove: _updateNote,
      onPointerUp: _stopNote,
      child: Container(
        color: Color.fromARGB(255, 234, 242, 227),
        child: ClipRect(
          child: CustomPaint(
            painter: KeyboardPainter(
              pixelsPerSemitone: pixelsPerSemitone
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
