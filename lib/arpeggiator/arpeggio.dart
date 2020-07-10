import 'player_action.dart';

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
