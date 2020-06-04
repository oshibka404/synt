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
      home: LayoutBuilder(
        builder: (context, constraints) {
          final double controlPanelWidth = constraints.maxHeight / 3;
          print("CP width: $controlPanelWidth, height: ${constraints.maxHeight}");
          print("Surface width: ${constraints.maxWidth - controlPanelWidth}, height: ${constraints.maxHeight}");
          return Row(
            children: [
              RecordControlPanel(
                size: Size(controlPanelWidth, constraints.maxHeight),
              ),
              Surface(
                size: Size(constraints.maxWidth - controlPanelWidth, constraints.maxHeight),
                offset: Offset(controlPanelWidth, 0),
              ),
            ],
          );
        },
      ),
    );
  }
}
