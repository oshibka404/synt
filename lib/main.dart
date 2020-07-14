import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:perfect_first_synth/synt_localizations.dart';

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
      localizationsDelegates: [
        const SyntLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('ru', ''),
      ],
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (BuildContext context) =>
          SyntLocalizations.of(context).getLocalized("Synt"),
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
