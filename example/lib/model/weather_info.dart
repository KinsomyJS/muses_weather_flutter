import 'dart:core';

import 'package:json_annotation/json_annotation.dart';
part 'weather_info.g.dart';

@JsonSerializable()
class WeatherInfo {
  String city;
  String cityid;
  List<Index> indexes;
  PM25 pm25;
  Realtime realtime;
  List<Weather> weathers;
}

@JsonSerializable()
class Index {
  String abbreviation;
  String content;
  String level;
  String name;
}

@JsonSerializable()
class PM25 {
  String aqi;
  String quality;
}

@JsonSerializable()
class Realtime {
  String temp;
  String time;
  String weather;
}

@JsonSerializable()
class Weather {
  String date;
  String temp_day_c;
  String temp_night_c;
  String weather;
  String week;
}
