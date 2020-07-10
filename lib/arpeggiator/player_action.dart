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
