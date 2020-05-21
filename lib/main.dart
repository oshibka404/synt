import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  static const platform = const MethodChannel('synth.ae/control');
  double gate = 0;
  double gain = 0.5;
  int paramsCount;

  @override
  void initState() {
    getInitialState();
    super.initState();
  }

  Future<int> getParamsCount() async {
    return await platform.invokeMethod('getParamsCount');
  }

  Future<double> getParamInit(int id) {
    try {
      return platform.invokeMethod('getParamInit', <String, int>{
        'id': id
      });
    } on PlatformException catch (e) {
      throw 'Unable to get initial value of param #$id: ${e.message}';
    }
  }

  Future<double> getParamValue(int id) {
    try {
      return platform.invokeMethod('getParamValue', <String, int>{
        'id': id
      });
    } on PlatformException catch (e) {
      throw 'Unable to get current value of param #$id: ${e.message}';
    }
  }

  Future<void> setParamValue(int id, double value) {
    try {
      return platform.invokeMethod('setParamValue', <String, dynamic>{
        'id': id,
        'value': value
      });
    } on PlatformException catch (e) {
      throw 'Unable to get initial value of param #$id: ${e.message}';
    }
  }

  getInitialState() async {
    int newParamsCount = await getParamsCount();
    double newGain = await getParamValue(0);
    double newGate = await getParamValue(1);

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
                setParamValue(1, newGate);
                setState(() {
                  gate = newGate;
                });
              },
              child: const Text('Play!', style: TextStyle(fontSize: 20)),
            ),
            Slider(
              onChanged: (newValue) {
                setParamValue(0, newValue);
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
