import 'package:flutter/material.dart';

import '../keyboard_preset.dart';

class KeyboardAction {
  KeyboardAction({
    @required this.voiceId,
    @required this.time,
    @required this.type,
    this.preset,
    this.stepOffset,
    this.pressure,
    this.modulation,
  });
  int voiceId;
  
  /// time when the event occured
  DateTime time;
  KeyboardActionType type;
  
  /// distance in scale steps (screen keys) from base key
  double stepOffset;
  
  /// normalized (0-1) pressure
  double pressure;

  /// normalized (0-1) vertical position of the pointer
  double modulation;

  KeyboardPreset preset;
}

enum KeyboardActionType {
  start, modify, stop
}
