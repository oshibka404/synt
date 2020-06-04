import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:perfect_first_synth/record_control.dart';
import 'package:perfect_first_synth/surface/surface.dart';

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
      theme: ThemeData.dark(),
      home: Row(
        children: [
          Expanded(
            child: Surface(),
          ),
          RecordControlPanel(),
        ],
      ),
    );
  }
}
