import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';
import 'package:muses_weather_flutter_example/model/weather_info.dart';
import 'package:muses_weather_flutter_example/page_cities.dart';
import 'package:muses_weather_flutter_example/page_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cities extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CitiesState();
  }
}

class CitiesState extends State<Cities> {
  Map<String, WeatherInfo> cityMap = Map();
  int count;
  @override
  void initState() {
    _getCitiesId().then((list) {
      for (String id in list) {
        _fetchWeatherInfo(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        floatingActionButton: new FloatingActionButton(
          onPressed: null,
          tooltip: 'add city',
          child: new Icon(Icons.add),
        ),
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          elevation: 2.0,
          backgroundColor: Colors.white,
          title: Text(
            "城市",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: new Center(
          child: new ListView(
            children: _buildCitiesWeather(cityMap),
          ),
        ),
      ),
    );
  }

  Future<List<String>> _getCitiesId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> ids = prefs.getStringList("citiesids");
    print("_getCitiesId ======" + ids.toString());
    if (ids != null && ids.length > 0) {
      count = ids.length;
      return ids;
    }
  }

  _fetchWeatherInfo(String id) async {
    var httpClient = new HttpClient();
    var uri = new Uri.http(
        'aider.meizu.com', '/app/weather/listWeather', {'cityIds': id});
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    try {
      if (response.statusCode == HttpStatus.ok) {
        var json = await response.transform(Utf8Decoder()).join();
        Map map = jsonDecode(json);
        print(map["value"][0].toString());
        cityMap[id] = WeatherInfo.fromJson(map["value"][0]);
        if (cityMap.length == count) {
          setState(() {
            cityMap;
          });
        }
      } else {
        print("============data is empty==============");
      }
    } catch (exception) {
      print("=============" + exception.toString() + "===============");
    }
  }

  List<Widget> _buildCitiesWeather(Map<String, WeatherInfo> maps) {
    print("_buildCitiesWeather============" + maps.values.length.toString());
    List<Widget> list = new List();
    for (WeatherInfo weatherInfo in maps.values) {
      list.add(_buildCityWeatherItem(weatherInfo));
    }
    return list;
  }

  Widget _buildCityWeatherItem(WeatherInfo weatherInfo) {
    String image = "images/bg_dy.png";
    String weather = weatherInfo.realtime.weather;
    if (weather.contains("多云")) {
      image = "images/bg_dy.png";
    } else if (weather.contains("晴")) {
      image = "images/sun.png";
    } else if (weather.contains("阴")) {
      image = "images/cloudy.png";
    } else if (weather.contains("雨")) {
      image = "images/rain.png";
    } else if (weather.contains("雷")) {
      image = "images/lightning.png";
    }
    print("_buildCityWeatherItem============ " + weatherInfo.city);

    return new InkWell(
      onTap: (){
        Navigator.push<String>(context, new MaterialPageRoute(builder: (BuildContext context){
          return new HomePage(weatherInfo.cityid.toString());
        }));
      },
      child: new Container(
          padding: EdgeInsets.only(top: 20.0),
          height: 150.0,
          alignment: Alignment.center,
          child: Card(
            child: new Stack(
              children: <Widget>[
                Container(
                  child: new Image.asset(image, fit: BoxFit.fill),
                  width: 300.0,
                ),
                Container(
                  width: 300.0,
                  decoration: BoxDecoration(
                      color: Color(
                    0x33000000,
                  )),
                  child: Column(
                    children: <Widget>[
                      Text(
                        weatherInfo.city,
                        style: TextStyle(fontSize: 22.0),
                      ),
                      Text(weatherInfo.realtime.weather),
                      Text(weatherInfo.realtime.temp + "℃")
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
