import '../controller/keyboard_preset.dart';
import '../controller/keyboard/keyboard_action.dart';

/// [KeyboardAction] with fixed [preset]
class Sample extends KeyboardAction {
  KeyboardPreset preset;
  Sample.from(KeyboardAction action, {this.preset}) : super.assign(action);
}
