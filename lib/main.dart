import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'controller/controller.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Synt',
      home: SafeArea(
        left: false,
        bottom: false,
        top: false,
        child: Material(child: Controller()),
      ),
      theme: themeData,
    );
  }
}
