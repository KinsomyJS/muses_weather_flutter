import 'dart:async';

import 'package:flutter/services.dart';

class MusesWeatherFlutter {
  static const MethodChannel _channel =
      const MethodChannel('muses_weather_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
