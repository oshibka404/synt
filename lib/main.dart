import 'package:flutter/material.dart';
import './dsp_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
    await DspAPI.start();
    double initGain = await DspAPI.getParamInit(0); // TODO(@oshibka404): use paths instead of IDs.
    double initGate = await DspAPI.getParamInitByPath('/Sample_synth/gate');
    double initMinGain = await DspAPI.getParamMin(0);
    double initMaxGain = await DspAPI.getParamMax(0);

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
                DspAPI.setParamValue(1, newGate);
                setState(() {
                  gate = newGate;
                });
              },
              child: Text((gate == 0) ? 'Play!' : 'Stop!', style: TextStyle(fontSize: 20)),
            ),
            Slider(
              onChanged: (newValue) {
                DspAPI.setParamValueByPath('/Sample_synth/gain', newValue);
                setState(() {
                  gain = newValue;
                });
              },
              value: gain,
              max: maxGain,
              min: minGain,
            ),
            Text(
              'Gate: $gate, Gain: $gain',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
