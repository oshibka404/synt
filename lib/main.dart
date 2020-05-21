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
  double gain = 0.5;
  int paramsCount;

  @override
  void initState() {
    getInitialState();
    super.initState();
  }

  getInitialState() async {
    int newParamsCount = await DspAPI.getParamsCount();
    double newGain = await DspAPI.getParamInit(0);
    double newGate = await DspAPI.getParamInit(1);

    setState(() {
      paramsCount = newParamsCount;
      gain = newGain;
      gate = newGate;
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
              onPressed: () async {
                double newGate = 1 - gate;
                DspAPI.setParamValue(1, newGate);
                setState(() {
                  gate = newGate;
                });
              },
              child: const Text('Play!', style: TextStyle(fontSize: 20)),
            ),
            Slider(
              onChanged: (newValue) {
                DspAPI.setParamValue(0, newValue);
                setState(() {
                  gain = newValue;
                });
              },
              value: gain,
              max: 1,
              min: 0
            ),
            Text(
              '$paramsCount parameters. Gate: $gate, Gain: $gain',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
