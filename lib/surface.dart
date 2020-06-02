import 'package:flutter/material.dart';
import 'package:perfect_first_synth/synth/synthesizer.dart';

class Surface extends StatefulWidget {
  Surface({Key key}) : super(key: key);

  @override
  _SurfaceState createState() => _SurfaceState();
}

class _SurfaceState extends State<Surface> {
  Synthesizer _synth = new Synthesizer();

  Map<int, Voice> _voices = {};

  void _playNote(PointerEvent details) async {
    Voice newVoice = _synth.newVoice(
      details.pointer,
      freq: details.position.dx,
      gain: 5 - details.position.dy / 100,
    );
    setState(() {
      _voices[details.pointer] = newVoice;
    });
  }

  void _updateNote(PointerEvent details) {
    _synth.modifyVoice(
      details.pointer, 
      freq: details.position.dx,
      gain: 5 - details.position.dy / 100,
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
    if (_voices.length == 0) {
      return [Text(
        'Not playing',
        style: Theme.of(context).textTheme.headline4,
      )];
    }
    List<Widget> pointerTexts = new List<Widget>();
    _voices.forEach((pointer, voice) {
      pointerTexts.add(Text(
        'Playing ${voice.params['freq']} Hz with gain ${voice.params['gain']}',
        style: Theme.of(context).textTheme.headline4,
      ));
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
        color: Color.fromARGB(255, 234, 242, 227),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _getPointersText(),
        ),
      ),
    );
  }
}
