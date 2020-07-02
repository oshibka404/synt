/// Monophonic linear sequence of [PlayerAction]s.
///
/// Played by [Arpeggiator].
class Arpeggio {
  List<PlayerAction> _actions;

  Arpeggio(this._actions);
  Arpeggio.fromJson(String json) {
    throw UnimplementedError("fromJson constructor is not implemented");
  }

  List<PlayerAction> get actions => _actions;
  PlayerAction operator [](int division) {
    return actions[division];
  }

  String toJson() {
    throw UnimplementedError("toJson method is not implemented");
  }

  Arpeggio withModulation(double modulation) => Arpeggio(
      actions.map((action) => action?.withModulation(modulation)).toList());
  Arpeggio withOffset(double offset) =>
      Arpeggio(actions.map((action) => action?.withOffset(offset)).toList());
  Arpeggio withVelocity(double velocity) => Arpeggio(
      actions.map((action) => action?.withVelocity(velocity)).toList());
}

/// Abstract action
///
/// Interpretation of the params is up to consumer
class PlayerAction {
  bool _isStop = false;

  /// Steps from base note.
  final double stepOffset;

  /// Abstract modulation of an external params.
  ///
  /// Supposed to be from 0 to 1
  final double modulation;

  /// Power of pressure or loudness or expression.
  ///
  /// Assumed to be released when equals to 0
  /// Supposedd to be from 0 to 1
  final double velocity;

  PlayerAction({
    this.stepOffset = 0,
    this.modulation = 1,
    this.velocity = 1,
  });

  PlayerAction.stop({
    this.stepOffset,
    this.modulation,
    this.velocity = 0,
  }) {
    _isStop = true;
  }

  PlayerAction withModulation(double newModulation) => _isStop
      ? this
      : PlayerAction(
          modulation: newModulation,
          velocity: velocity,
          stepOffset: stepOffset,
        );

  PlayerAction withOffset(double newOffset) => _isStop
      ? this
      : PlayerAction(
          modulation: modulation,
          velocity: velocity,
          stepOffset: stepOffset != null ? newOffset + stepOffset : null,
        );

  PlayerAction withVelocity(double newVelocity) => _isStop
      ? this
      : PlayerAction(
          velocity: newVelocity,
          modulation: modulation,
          stepOffset: stepOffset,
        );
}
