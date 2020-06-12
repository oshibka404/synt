import 'package:flutter/material.dart';
import 'package:perfect_first_synth/controller/keyboard/keyboard_action.dart';

/// Timeline with sequence of [KeyboardAction]s 
class Record {
  Record({
    @required this.startTime,
    @required this.startPoint,
  });
  final Offset startPoint;
  final DateTime startTime;
  List<KeyboardAction> actions;

}