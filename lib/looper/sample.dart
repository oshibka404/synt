import '../controller/keyboard/keyboard_action.dart';
import '../controller/keyboard_preset.dart';

/// [KeyboardAction] with fixed [preset]
// TODO: Rename to trig
class Sample extends KeyboardAction {
  KeyboardPreset preset;
  Sample.from(KeyboardAction action, {this.preset}) : super.assign(action);
}
