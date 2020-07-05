import 'package:flutter/material.dart';

import 'pointer_data.dart';

class RealPointerData implements PointerData {
  final Offset position;
  final double pressure;
  RealPointerData({this.position, this.pressure});
}
