import 'package:flutter/material.dart';

abstract class PointerData {
  Offset get position;
  double get pressure;
}
