import 'package:flutter/services.dart';
import 'package:perfect_first_synth/dsp_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Faust DSP API', () {
    test('Class has static member `platform`', () {
      expect(DspApi.platform, isA<MethodChannel>());
    });
  });
}
