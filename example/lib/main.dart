import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:muses_weather_flutter/muses_weather_flutter.dart';
import 'package:muses_weather_flutter_example/home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return new HomePage();
  }
}



