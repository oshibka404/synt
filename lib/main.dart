import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'controller/controller.dart';

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
      home: Controller(),
    );
  }
}
