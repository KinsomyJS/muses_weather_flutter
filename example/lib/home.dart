import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muses_weather_flutter_example/model/weather_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  double screenWidth = 0.0;
  File _image;
  WeatherInfo weatherInfo = new WeatherInfo(realtime: new Realtime(),pm25: new PM25(),indexes: new List(),weathers: new List());

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      _setImagePath(_image.path);
    });
  }

  @override
  void initState() {
    _getImagePath();
    _fetchWeatherInfo("101190101");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return new MaterialApp(
      home: new Scaffold(
        floatingActionButton: new FloatingActionButton(
          onPressed: getImage,
          tooltip: 'Pick Image',
          child: new Icon(Icons.photo_library),
        ),
        resizeToAvoidBottomPadding: false, //false键盘弹起不重新布局 避免挤压布局
        body: new Stack(
          children: <Widget>[
            new Container(
              child: _image == null
                  ? null
                  : new Image.file(_image, fit: BoxFit.fill),
              height: double.infinity,
              width: double.infinity,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: EdgeInsets.only(top: 30.0),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color(
                  0x66000000,
                )),
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: new Theme(
                          data: theme.copyWith(primaryColor: Colors.white),
                          child: new TextField(
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.white), //输入文本的样式
                            decoration: InputDecoration(
//                              //bug doesn't work
//                              border: new UnderlineInputBorder(
//                                  borderSide: new BorderSide(
//                                      color: Colors.white,
//                                      style: BorderStyle.solid)),
                              hintText: '查询其他城市',
                              hintStyle: TextStyle(
                                  fontSize: 14.0, color: Colors.white),
                              prefixIcon: new Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 20.0,
                              ),
                            ),
                          ),
                        )),
                    Container(
                      margin: EdgeInsets.only(top: 30.0),
                      child: Text(
                        weatherInfo.city==null?"XX":weatherInfo.city,
                        style: new TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w100),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 40.0),
                      child: Text(
                        (weatherInfo.realtime.temp??="XX") + "℃",
                        style: new TextStyle(
                            fontSize: 80.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 40.0),
                      child: Text(
                        weatherInfo.realtime.weather??="XX",
                        style: new TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w100),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15.0),
                      child: new Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey,
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
                          child: Text(
                            (weatherInfo.pm25.aqi??="00")+ " " +  (weatherInfo.pm25.quality??="未知"),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      color: Color(0x3399CCFF),
                      child: Row(
                        children: <Widget>[
                          _buildFutureWeather(weatherInfo.weathers[0].week,weatherInfo.weathers[0].weather,weatherInfo.weathers[0].temp_day_c+ " ~ "+weatherInfo.weathers[0].temp_night_c),
                          _buildFutureWeather(weatherInfo.weathers[1].week,weatherInfo.weathers[1].weather,weatherInfo.weathers[1].temp_day_c+ " ~ "+weatherInfo.weathers[1].temp_night_c),
                          _buildFutureWeather(weatherInfo.weathers[2].week,weatherInfo.weathers[2].weather,weatherInfo.weathers[2].temp_day_c+ " ~ "+weatherInfo.weathers[2].temp_night_c),
                          _buildFutureWeather(weatherInfo.weathers[3].week,weatherInfo.weathers[3].weather,weatherInfo.weathers[3].temp_day_c+ " ~ "+weatherInfo.weathers[3].temp_night_c),
                        ],
                      ),
                    ),
                    _buildLivingIndex(),
                    _buildLivingIndex(),
                    _buildLivingIndex(),
                    _buildLivingIndex(),
                    _buildLivingIndex(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFutureWeather(String week,String weather,String temp) {
    return new Expanded(
      flex: 1,
      child: new Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 10.0)),
          Text(
            week,
            style: TextStyle(color: Colors.white),
          ),
          Padding(padding: EdgeInsets.only(top: 10.0)),
          Text(
            temp+"℃",
            style: TextStyle(color: Colors.white),
          ),
          Padding(padding: EdgeInsets.only(top: 10.0)),
          Text(
            weather,
            style: TextStyle(color: Colors.white),
          ),
          Padding(padding: EdgeInsets.only(top: 10.0)),
        ],
      ),
    );
  }

  Widget _buildLivingIndex() {
    return new Container(
      color: Color(0x3399CCFF),
      margin: EdgeInsets.only(top: 10.0),
      padding:
          EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
      child: Row(
        children: <Widget>[
          Image.asset("images/clothing.png", width: 40.0, fit: BoxFit.fitWidth),
          Padding(padding: EdgeInsets.only(right: 10.0)),
          Column(
            children: <Widget>[
              Container(
                child: Text("穿衣指数 较舒适", style: TextStyle(color: Colors.white)),
                width: 280.0,
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              Container(
                child: Text("建议着薄外套、开衫牛仔裤等服装。年老体弱者应当适当添加衣物，宜着夹克衫、薄毛衣等。",
                    style: TextStyle(color: Colors.white, fontSize: 12.0)),
                width: 280.0,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _getImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String path = prefs.get("bgpath");
    setState(() {
      _image = new File(path);
    });
  }

  _setImagePath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("bgpath", path);
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
        setState(() {
          weatherInfo = WeatherInfo.fromJson(map["value"][0]);
        });
        print(weatherInfo.city);
      } else {
        print("============data is empty==============");
      }
    } catch (exception) {
      print("============="+exception.toString()+"===============");
    }
  }
}
