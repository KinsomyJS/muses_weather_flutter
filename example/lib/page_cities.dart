import 'package:flutter/material.dart';

class CitiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        builder = (BuildContext _) => Cities();

        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}

class Cities extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CitiesState();
  }
}

class CitiesState extends State<Cities> {
  @override
  void initState() {}
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        body: _buildCityWeatherItem(),
      ),
    );
  }
}

Widget _buildCityWeatherItem() {
  return new Stack(
    children: <Widget>[
      Container(
        child: new Image.asset("images/bg_dy.jpg", fit: BoxFit.fill),
        width: double.infinity,
      ),
      Container(
        decoration: BoxDecoration(
            color: Color(
          0x66000000,
        )),
        child: Column(
          children: <Widget>[Text("南京"), Text("多云"), Text("15 ~ 28")],
        ),
      )
    ],
  );
}
