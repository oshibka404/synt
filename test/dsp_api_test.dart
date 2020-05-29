import 'package:perfect_first_synth/synth/dsp_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Faust DSP API', () {
    test('getFullPath returns its argument when no commonPathPrefix', () {
      expect(DspApi.getFullPath('test'), 'test');
    });
    test('getFullPath concatenates its argument with given commonPathPrefix', () {
      DspApi.commonPathPrefix = 'foo/';
      expect(DspApi.getFullPath('bar'), 'foo/bar');
    });
  });
}
