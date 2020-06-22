import 'package:flutter/material.dart';

import '../keyboard_preset.dart';

class KeyboardAction {
  /// Creates copy of a given [action] with overriden properties
  KeyboardAction.assign(KeyboardAction action, {
    this.voiceId,
    DateTime time,
    KeyboardActionType type,
    KeyboardPreset preset,
    double stepOffset,
    double pressure,
    double modulation,
  }) {
    this.voiceId = voiceId ?? action.voiceId;
    this.time = time ?? action.time;
    this.type = type ?? action.type;
    this.preset = preset ?? action.preset;
    this.stepOffset = stepOffset ?? action.stepOffset;
    this.pressure = pressure ?? action.pressure;
    this.modulation = modulation ?? action.modulation;
  }

  /// Creates action of type [KeyboardActionType.stop] for Voice #[voiceId]
  KeyboardAction.stop(this.voiceId) {
    this.time = DateTime.now();
    this.type = KeyboardActionType.stop;
  }

  KeyboardAction.start({
    @required this.voiceId,
    this.preset,
    this.stepOffset,
    this.pressure,
    this.modulation,
  }) {
    this.time = DateTime.now();
    this.type = KeyboardActionType.start;
  }

  KeyboardAction.modify({
    @required this.voiceId,
    this.preset,
    this.stepOffset,
    this.pressure,
    this.modulation,
  }) {
    this.time = DateTime.now();
    this.type = KeyboardActionType.modify;
  }

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
