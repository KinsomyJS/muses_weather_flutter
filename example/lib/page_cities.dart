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

const String _explanatoryText =
    "When the Scaffold's floating action button changes, the new button fades and "
    'turns into view. In this demo, changing tabs can cause the app to be rebuilt '
    'with a FloatingActionButton that the Scaffold distinguishes from the others '
    'by its key.';

class Cities extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CitiesState();
  }
}

class CitiesState extends State<Cities> {
  static String idSelected;
  Map<String, WeatherInfo> cityMap;
  int count;
  final searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    cityMap = Map();
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
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton.extended(
            tooltip: 'Show textfield',
            icon: Icon(Icons.add),
            label: new Text("城市"),
            onPressed: _showCityTextField),
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
        body: new RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          child: new Center(
            child: new ListView(
              children: _buildCitiesWeather(cityMap),
            ),
          ),
        ),
      ),
    );
  }

  void _showCityTextField() {
    _scaffoldKey.currentState.showBottomSheet<Null>((BuildContext context) {
      return new Container(
          decoration: new BoxDecoration(
              border: new Border(
                  top: new BorderSide(color: Theme.of(context).dividerColor))),
          child: new Padding(
            padding: const EdgeInsets.all(32.0),
            child: new TextField(
              controller: searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (String name) {
                searchController.clear();
                Navigator.pop(context);
                _setCitiesId(HomePageState.getIdByName(name)).then((_) {
                  _refreshIndicatorKey.currentState.show();
                });
              },
              maxLines: 1,
              style: TextStyle(fontSize: 16.0, color: Colors.grey), //输入文本的样式
              decoration: InputDecoration(
                hintText: '查询其他城市',
                hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey),
                prefixIcon: new Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: 20.0,
                ),
              ),
            ),
          ));
    });
  }

  Future<Null> _handleRefresh() {
    initState();
    final Completer<Null> completer = new Completer<Null>();
    new Timer(const Duration(seconds: 1), () {
      completer.complete(null);
    });
    return completer.future.then((_) {
      _scaffoldKey.currentState?.showSnackBar(
          new SnackBar(content: const Text('刷新成功'), action: null));
    });
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

  Future<void> _setCitiesId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> ids = prefs.getStringList("citiesids");
    if (ids == null) {
      ids = new List();
    }
    if (!ids.contains(id)) {
      ids.add(id);
    }
    await prefs.setStringList("citiesids", ids);
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
      onTap: () {
        idSelected = weatherInfo.cityid.toString();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      },
      child: new Container(
          padding: EdgeInsets.only(top: 20.0,left: 20.0,right: 20.0),
          height: 200.0,
          alignment: Alignment.center,
          child: Card(
            child: new Stack(
              children: <Widget>[
                Container(
                  child: new Image.asset(image, fit: BoxFit.fill),
                  height: 200.0,
                  width: double.infinity,
                ),
                Container(
                    decoration: BoxDecoration(
                        color: Color(
                      0x33000000,
                    )),
                    child: Container(
                      padding: EdgeInsets.only(top: 10.0, left: 20.0),
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: <Widget>[
                          Text(
                            weatherInfo.city,
                            style: TextStyle(fontSize: 22.0),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                          ),
                          Container(
                              child: Text(
                            weatherInfo.realtime.weather,
                            style: TextStyle(fontSize: 18.0),
                          )),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                          ),
                          Text(
                            weatherInfo.realtime.temp + "℃",
                            style: TextStyle(fontSize: 18.0),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          )),
    );
  }
}
