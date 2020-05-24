import 'package:flutter/services.dart';

class DspAPI {
  static const platform = const MethodChannel('synth.ae/control');

  static Future<bool> start() {
    try {
      return platform.invokeMethod('start');
    } on PlatformException catch (e) {
      throw 'Could not start audio processing: ${e.message}';
    }
  }

  static Future<bool> isRunning() {
    try {
      return platform.invokeMethod('isRunning');
    } on PlatformException catch (e) {
      throw 'Could not get audio processing running state: ${e.message}';
    }
  }

  static Future<void> stop() {
    try {
      return platform.invokeMethod('stop');
    } on PlatformException catch (e) {
      throw 'Could not stop audio processing: ${e.message}';
    }
  }

  static Future<int> getParamsCount() {
    try {
      return platform.invokeMethod('getParamsCount');
    } on PlatformException catch (e) {
      throw 'Unable to get params count: ${e.message}';
    }
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

  static Future<double> getParamInitByPath(String path) {
    try {
      return platform.invokeMethod('getParamInitByPath', <String, String>{
        'path': path
      });
    } on PlatformException catch (e) {
      throw 'Unable to get initial value of param "$path": ${e.message}';
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

  static Future<double> getParamMinByPath(String path) {
    try {
      return platform.invokeMethod('getParamMinByPath', <String, String>{
        'path': path
      });
    } on PlatformException catch (e) {
      throw 'Unable to get min value of param "$path": ${e.message}';
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

  static Future<double> getParamMaxByPath(String path) {
    try {
      return platform.invokeMethod('getParamMaxByPath', <String, String>{
        'path': path
      });
    } on PlatformException catch (e) {
      throw 'Unable to get max value of param "$path": ${e.message}';
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

  static Future<double> getParamValueByPath(String path) {
    try {
      return platform.invokeMethod('getParamValueByPath', <String, String>{
        'path': path
      });
    } on PlatformException catch (e) {
      throw 'Unable to get current value of param "$path": ${e.message}';
    }
  }

  static Future<void> setParamValue(int id, double value) {
    try {
      return platform.invokeMethod('setParamValue', <String, dynamic>{
        'id': id,
        'value': value
      });
    } on PlatformException catch (e) {
      throw 'Unable to set value for param #$id: ${e.message}';
    }
  }

  static Future<void> setParamValueByPath(String path, double value) {
    try {
      return platform.invokeMethod('setParamValueByPath', <String, dynamic>{
        'path': path,
        'value': value
      });
    } on PlatformException catch (e) {
      throw 'Unable to set value for param "$path": ${e.message}';
    }
  }

  static Future<int> keyOn(int pitch, int velocity) {
    try {
      return platform.invokeMethod('keyOn', <String, int>{
        'pitch': pitch,
        'value': velocity
      });
    } on PlatformException catch (e) {
      throw 'Unable to instantiate voice for key $pitch with velocity $velocity: ${e.message}';
    }
  }

  static Future<int> keyOff(int pitch) {
    try {
      return platform.invokeMethod('keyOff', <String, int>{
        'pitch': pitch
      });
    } on PlatformException catch (e) {
      throw 'Unable to stop the voice of key $pitch: ${e.message}';
    }
  }

  static Future<void> allNotesOff() {
    try {
      return platform.invokeMethod('allNotesOff');
    } on PlatformException catch (e) {
      throw 'Unable to stop all voices: ${e.message}';
    }
  }

  static Future<int> newVoice() {
    try {
      return platform.invokeMethod('newVoice');
    } on PlatformException catch (e) {
      throw 'Unable to instantiate new voice: ${e.message}';
    }
  }

  static Future<int> deleteVoice(int voice) {
    try {
      return platform.invokeMethod('deleteVoice', <String, int>{
        'voice': voice
      });
    } on PlatformException catch (e) {
      throw 'Unable to delete voice #$voice: ${e.message}';
    }
  }
}
