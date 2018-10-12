import 'dart:core';

import 'package:json_annotation/json_annotation.dart';
part 'weather_info.g.dart';

@JsonSerializable()
class WeatherInfo {
  String city;
  int cityid;
  List<Index> indexes;
  PM25 pm25;
  Realtime realtime;
  List<Weather> weathers;
  WeatherInfo({this.city,this.cityid,this.indexes,this.pm25,this.realtime,this.weathers});
  factory WeatherInfo.fromJson(Map<String, dynamic> json) => _$WeatherInfoFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherInfoToJson(this);
}

@JsonSerializable()
class Index {
  String abbreviation;
  String content;
  String level;
  String name;
  Index({this.abbreviation,this.content,this.level,this.name});
  factory Index.fromJson(Map<String, dynamic> json) => _$IndexFromJson(json);
  Map<String, dynamic> toJson() => _$IndexToJson(this);
}

@JsonSerializable()
class PM25 {
  String aqi;
  String quality;
  PM25({this.aqi,this.quality});
  factory PM25.fromJson(Map<String, dynamic> json) => _$PM25FromJson(json);
  Map<String, dynamic> toJson() => _$PM25ToJson(this);
}

@JsonSerializable()
class Realtime {
  String temp;
  String time;
  String weather;
  Realtime({this.temp,this.time,this.weather});
  factory Realtime.fromJson(Map<String, dynamic> json) => _$RealtimeFromJson(json);
  Map<String, dynamic> toJson() => _$RealtimeToJson(this);
}

@JsonSerializable()
class Weather {
  String date;
  String temp_day_c;
  String temp_night_c;
  String weather;
  String week;
  Weather({this.date,this.temp_day_c,this.temp_night_c,this.weather,this.week});
  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}
