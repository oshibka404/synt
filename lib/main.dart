import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './dsp_api.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perfect First Synth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Perfect First Synthesizer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double gate = 0;
  double gain = 0;
  double minGain = 0;
  double maxGain = 0;
  double freq = 440;

  @override
  void initState() {
    _getInitialState();
    DspApi.commonPathPrefix = '/Perfect_First_Synth/';
    super.initState();
  }

  void _updateNote(PointerEvent details) {
    DspApi.setParamValueByPath('gain', 1 / details.position.dy * 10);
    DspApi.setParamValueByPath('freq', details.position.dx);
    setState(() {
      freq = details.position.dx;
      gain = 1/details.position.dy * 10;
    });
  }

  void _playNote(PointerEvent details) {
    DspApi.setParamValueByPath('gain', 1 / details.position.dy * 10);
    DspApi.setParamValueByPath('freq', details.position.dx);
    DspApi.setParamValueByPath('gate', 1);
    setState(() {
      gate = 1;
      freq = details.position.dx;
      gain = 1/details.position.dy * 10;
    });
  }

  void _stopNote(PointerEvent details) {
    DspApi.setParamValueByPath('gate', 0);
    setState(() {
      gate = 0;
    });
  }

  _getInitialState() async {
    await DspApi.start();
    double initGate = await DspApi.getParamInitByPath('gate');
    double initGain = await DspApi.getParamInitByPath('gain');
    double initMinGain = await DspApi.getParamMinByPath('gain');
    double initMaxGain = await DspApi.getParamMaxByPath('gain');

    setState(() {
      gain = initGain;
      gate = initGate;
      minGain = initMinGain;
      maxGain = initMaxGain;
    });
  }

  _getText() {
    if (gate > 0) {
      return 'Playing ${freq.round()} Hz with gain ${(gain * 100).round()}';
    } else {
      return 'Not playing';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tight(Size(300.0, 200.0)),
      child: Listener(
        onPointerDown: _playNote,
        onPointerMove: _updateNote,
        onPointerUp: _stopNote,
        child: Container(
          color: Colors.lightBlueAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _getText(),
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
