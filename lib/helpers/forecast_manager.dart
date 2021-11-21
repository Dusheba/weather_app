import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

String idAPI = "5afa0f095e31e5b72e0d15b4c0dbeed4";

String takeWeekIcon(String str){
  switch(str)
  {
    case "Rain":
      return "rainy";
    case "Snow":
      return "snowy";
    case "Clear":
      return "sunny";
    case "Drizzle":
      return "rainy";
    case "Clouds":
      return "cloudy";
    case "Thunderstorm":
      return "stormy";
    default:
      return "sun";
  }
}

String takeWeatherIcon(String str){
  switch(str)
  {
    case "Rain":
      return "rainfall";
    case "Thunderstorm":
      return "flash";
    case "Clear":
      return "sun";
    case "Clouds":
      return "rain";
    case "Drizzle":
      return "rain";
    default:
      return "sun";
  }
}

class Weather {
  final int current;
  final String location;
  final String name;
  final int humidity;
  final int pressure;
  final int wind;
  final String time;
  final String image;
  final String day;

  Weather(
      {
        required this.current,
        required this.location,
        required this.name,
        required this.day,
        required this.humidity,
        required this.time,
        required this.pressure,
        required this.image,
        required this.wind,
      }
      );
}

Future<List> getWeatherData(String lat, String lon, String city) async {
  DateTime d = DateTime.now();
  var request = "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&units=metric&appid=$idAPI";
  var response = await http.get(Uri.parse(request));
  if (response.statusCode == 200) {
    var res = json.decode(response.body);
    var current = res["current"];

    Weather curTemp = Weather(
        pressure: current["pressure"]?.round() ?? 0,
        wind: current["wind_speed"]?.round() ?? 0,
        humidity: current["humidity"]?.round() ?? 0,
        name: current["weather"][0]["main"].toString(),
        time: "",
        location: city,
        day: DateFormat.yMMMd('ru').format(d),
        image: takeWeatherIcon(current["weather"][0]["main"].toString()),
        current: current["temp"]?.round() ?? 0,
    );

    List<Weather> todayForecast = [];
    int timeHour = int.parse(DateFormat.H('ru').format(d));
    for (var val = 0; val < 13; val += 3) {
      int sum = timeHour + val;
      if(sum > 23){
        sum = sum - 24;
      }
      var temp = res["hourly"];
      var hourly = Weather(
          name: "",
          humidity: temp[sum]["humidity"]?.round() ?? 0,
          pressure: temp[sum]["pressure"]?.round() ?? 0,
          day: "",
          current: temp[sum]["temp"]?.round() ?? 0,
          location: city,
          wind: temp[sum]["wind_speed"]?.round() ?? 0,
          image: takeWeatherIcon(temp[sum]["weather"][0]["main"].toString()),
          time: Duration(hours: sum).toString().split(":")[0] + ":00"
      );
      todayForecast.add(hourly);
    }
    List<Weather> weekForecast = [];
    for(var i = 0; i < 8; i++){
      DateTime _date = DateTime.now();
      _date = _date.add(Duration(days: i));
      String day = DateFormat.MMMMd('ru').format(_date);
      var temp = res["daily"][i];
      var hourly = Weather(
          pressure: temp["pressure"]?.round() ?? 0,
          humidity: temp["humidity"]?.round() ?? 0,
          image:takeWeekIcon(temp["weather"][0]["main"].toString()),
          name:temp["weather"][0]["main"].toString(),
          day: day,
          wind: temp["wind_speed"]?.round() ?? 0,
          location: city,
          current: temp["temp"]["day"]?.round() ?? 0,
          time:""
      );
      weekForecast.add(hourly);
    }
    return [
      curTemp,
      todayForecast,
      weekForecast
    ];
  }
  return [
    null,
    null,
    null
  ];
}

class City{
  final String name;
  var cityName;
  final double lat;
  final double lon;
  City({required this.name, required this.cityName, required this.lat,required this.lon});

  Map<String, dynamic> toJson() => {
    'name': name,
    'local_names': cityName,
    'lat': lat,
    'lon': lon
  };
  factory City.fromJson(Map<String, dynamic> json) {
    return City(name: json['name'],
        cityName: (json['local_names']['ru'] ?? json['name']) ,
        lat: json['lat'], lon: json['lon']);
  }
}