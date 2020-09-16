import '../controller/keyboard/keyboard_action.dart';
import '../controller/keyboard_preset.dart';

/// [KeyboardAction] with fixed [preset]
class Trig extends KeyboardAction {
  KeyboardPreset preset;
  Trig.from(KeyboardAction action, {this.preset}) : super.assign(action);
}
