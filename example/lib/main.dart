import 'package:flutter/material.dart';
import 'package:muses_weather_flutter_example/page_cities.dart';

import 'package:muses_weather_flutter_example/page_home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      routes: <String, WidgetBuilder> {
        '/home': (BuildContext context) => HomePage(CitiesState.idSelected),
      },
      home: HomePage(null),
    );
  }
}



