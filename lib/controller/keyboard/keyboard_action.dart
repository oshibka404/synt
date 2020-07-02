/// A command performed on [Keyboard].
///
/// Uses [pointerId] as a unique voice/pointer identifier.
/// Leaves interpretation to consumer. Operates only abstract substances
/// such as [pressure] (0-1),
/// [stepOffset] (number of scale steps from [Keyboard]'s baseNote) and
/// [modulation] which can modulate any voice param.
class KeyboardAction {
  int pointerId;

  /// time when the event occured
  DateTime time;

  /// distance in scale steps (screen keys) from base key
  double stepOffset;

  /// normalized (0-1) pressure
  double pressure;

  /// normalized (0-1) vertical position of the pointer
  double modulation;

  /// Creates copy of a given [action] with overriden properties
  KeyboardAction.assign(
    KeyboardAction action, {
    this.pointerId,
    DateTime time,
    double stepOffset,
    double pressure,
    double modulation,
  }) {
    this.pointerId = pointerId ?? action.pointerId;
    this.time = time ?? action.time;
    this.stepOffset = stepOffset ?? action.stepOffset;
    this.pressure = pressure ?? action.pressure;
    this.modulation = modulation ?? action.modulation;
  }

  /// pointer #[pointerId] is either created or modified
  KeyboardAction.press(
    this.pointerId, {
    this.stepOffset,
    this.pressure,
    this.modulation,
  }) {
    this.time = DateTime.now();
  }

  /// Creates action of type [KeyboardActionType.release] for pointer #[pointerId]
  KeyboardAction.release(this.pointerId) {
    this.time = DateTime.now();
    this.pressure = 0;
  }
}
