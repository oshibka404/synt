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

  @override
  void initState() {
    getInitialState();
    super.initState();
  }

  getInitialState() async {
    await DspApi.start();
    double initGate = await DspApi.getParamInitByPath('/Perfect_First_Synth/gate');
    double initGain = await DspApi.getParamInitByPath('/Perfect_First_Synth/gain');
    double initMinGain = await DspApi.getParamMinByPath('/Perfect_First_Synth/gain');
    double initMaxGain = await DspApi.getParamMaxByPath('/Perfect_First_Synth/gain');

    setState(() {
      gain = initGain;
      gate = initGate;
      minGain = initMinGain;
      maxGain = initMaxGain;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                double newGate = 1 - gate;
                DspApi.setParamValueByPath('/Perfect_First_Synth/gate', newGate);
                setState(() {
                  gate = newGate;
                });
              },
              child: Text((gate == 0) ? 'Play!' : 'Stop!', style: TextStyle(fontSize: 20)),
            ),
            Slider(
              onChanged: (newValue) {
                DspApi.setParamValueByPath('/Perfect_First_Synth/gain', newValue);
                setState(() {
                  gain = newValue;
                });
              },
              value: gain,
              max: maxGain,
              min: minGain,
            ),
            Text(
              'Gate: ${gate.toStringAsFixed(0)}, Volume: ${(gain * 100).round()}',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
