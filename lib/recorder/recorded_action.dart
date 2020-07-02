import 'package:perfect_first_synth/controller/keyboard_preset.dart';

import '../controller/keyboard/keyboard_action.dart';

/// [KeyboardAction] with fixed [preset]
class RecordedAction extends KeyboardAction {
  KeyboardPreset preset;
  RecordedAction.from(KeyboardAction action, {this.preset})
      : super.assign(action);
}
