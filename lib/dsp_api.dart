import 'package:flutter/services.dart';

class DspAPI {
  static const platform = const MethodChannel('synth.ae/control');

  static Future<int> getParamsCount() async {
    return await platform.invokeMethod('getParamsCount');
  }

  static Future<double> getParamInit(int id) {
    try {
      return platform.invokeMethod('getParamInit', <String, int>{
        'id': id
      });
    } on PlatformException catch (e) {
      throw 'Unable to get initial value of param #$id: ${e.message}';
    }
  }

  static Future<double> getParamMin(int id) {
    try {
      return platform.invokeMethod('getParamMin', <String, int>{
        'id': id
      });
    } on PlatformException catch (e) {
      throw 'Unable to get min value of param #$id: ${e.message}';
    }
  }

  static Future<double> getParamMax(int id) {
    try {
      return platform.invokeMethod('getParamMax', <String, int>{
        'id': id
      });
    } on PlatformException catch (e) {
      throw 'Unable to get max value of param #$id: ${e.message}';
    }
  }

  static Future<double> getParamValue(int id) {
    try {
      return platform.invokeMethod('getParamValue', <String, int>{
        'id': id
      });
    } on PlatformException catch (e) {
      throw 'Unable to get current value of param #$id: ${e.message}';
    }
  }

  static Future<void> setParamValue(int id, double value) {
    try {
      return platform.invokeMethod('setParamValue', <String, dynamic>{
        'id': id,
        'value': value
      });
    } on PlatformException catch (e) {
      throw 'Unable to get initial value of param #$id: ${e.message}';
    }
  }
  
}
