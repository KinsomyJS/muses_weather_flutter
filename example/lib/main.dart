import 'package:flutter/material.dart';
import 'package:muses_weather_flutter_example/page_cities.dart';

import 'package:muses_weather_flutter_example/page_home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        '/cities': (BuildContext context) => new CitiesPage(),
      },
    );
  }
}



