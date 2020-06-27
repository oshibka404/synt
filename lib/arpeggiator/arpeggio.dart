/// Monophonic linear sequence of [PlayerAction]s.
///
/// Played by [Arpeggiator].
class Arpeggio {
  Arpeggio(this._actions);

  List<PlayerAction> _actions;
  List<PlayerAction> get actions => _actions;

  Arpeggio.fromJson(String json) {
    throw UnimplementedError("fromJson constructor is not implemented");
  }
  String toJson() {
    throw UnimplementedError("toJson method is not implemented");
  }

  operator [](int division) {
    return actions[division];
  }
}

/// Abstract action
///
/// Interpretation of the params is up to consumer
class PlayerAction {
  PlayerAction({
    this.stepOffset = 0,
    this.modulation = 1,
    this.velocity = 1,
  });

  PlayerAction.stop({
    this.stepOffset,
    this.modulation,
    this.velocity = 0,
  });

  /// Steps from base note.
  final int stepOffset;

  /// Abstract modulation of an external params.
  ///
  /// Supposed to be from 0 to 1
  final double modulation;

  /// Power of pressure or loudness or expression.
  ///
  /// Assumed to be released when equals to 0
  /// Supposedd to be from 0 to 1
  final double velocity;
}
