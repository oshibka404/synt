abstract class FaustControl {
  FaustControl(this.type, this.label, this.address);
  final String type;
  final String label;
  final String address;

  factory FaustControl.create(Map<String, dynamic> control) {
    FaustControl createControl(item) => FaustControl.create(item);
    if (['hgroup', 'vgroup', 'tgroup'].contains(control['type'])) {
      List items = control['items'];
      var controls = items?.map<FaustControl>(createControl);
      return FaustGroup(
          control['label'], control['address'], controls?.toList());
    } else if (['hslider', 'vslider'].contains(control['type'])) {
      return FaustSlider(control['label'], control['address'],
          min: control['min'].toDouble(),
          max: control['max'].toDouble(),
          initialValue: control['init'].toDouble(),
          step: control['step'].toDouble());
    } else if (control['type'] == 'button') {
      return FaustButton(
        control['label'],
        control['address'],
      );
    } else if (control['type'] == 'checkbox') {
      return FaustCheckbox(
        control['label'],
        control['address'],
      );
    } else {
      throw ArgumentError.value(
          control, "control", "control['type'] is not supported");
    }
  }
}

class FaustGroup extends FaustControl {
  FaustGroup(String label, String address, this.items)
      : super('vgroup', label, address);

  final List<FaustControl> items;
}

class FaustSlider extends FaustControl {
  FaustSlider(String label, String address,
      {this.min, this.max, this.initialValue, this.step})
      : super('hslider', label, address);
  final double min;
  final double max;
  final double initialValue;
  final double step;
}

class FaustCheckbox extends FaustControl {
  FaustCheckbox(String label, String address)
      : super('checkbox', label, address);
}

class FaustButton extends FaustControl {
  FaustButton(String label, String address) : super('button', label, address);
}
