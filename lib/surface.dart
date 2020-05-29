import 'package:flutter/material.dart';
import 'package:perfect_first_synth/synth/synthesizer.dart';

class Surface extends StatefulWidget {
  Surface({Key key}) : super(key: key);

  @override
  _SurfaceState createState() => _SurfaceState();
}

class _SurfaceState extends State<Surface> {
  Synthesizer _synth = new Synthesizer();

  Map<int, Offset> pointers = {};

  Map<int, Voice> _voices = {};

  void _playNote(PointerEvent details) async {
    setState(() {
      pointers[details.pointer] = details.position;
    });
    // _voices[details.pointer] = await _synth.newVoice(
    //   details.pointer,
    //   freq: details.position.dx,
    //   gain: details.pressure
    // );
  }

  void _updateNote(PointerEvent details) {
    setState(() {
      pointers[details.pointer] = details.position;
    });
    // _synth.modifyVoice(
    //   details.pointer, 
    //   freq: details.position.dx,
    //   gain: details.pressure
    // );
  }

  void _stopNote(PointerEvent details) {
    setState(() {
      pointers.remove(details.pointer);
    });
    // _synth.stopVoice(details.pointer);
    // _voices.remove(details.pointer);
  }

  List<Widget> _getPointersText() {
    if (pointers.length == 0) {
      return [Text(
        'Not playing',
        style: Theme.of(context).textTheme.headline4,
      )];
    }
    List<Widget> pointerTexts = new List<Widget>();
    pointers.forEach((pointer, voice) {
      pointerTexts.add(Text(
        'Pointer $pointer. Playing ${voice.dx.round()} Hz with gain ${voice.dy.round()}',
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
        color: Colors.lightBlueAccent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _getPointersText(),
        ),
      ),
    );
  }
}
