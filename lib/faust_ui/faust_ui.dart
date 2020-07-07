import 'faust_control.dart';

/// Abstract description of Faust parameters
class FaustUi {
  int inputs;
  int outputs;
  String name;
  String fileName;

  List<FaustControl> items;

  FaustUi.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        fileName = json['fileName'],
        inputs = json['inputs'],
        outputs = json['outputs'],
        items = json['ui']
            ?.map<FaustControl>((item) => FaustControl.create(item))
            ?.toList();
}
