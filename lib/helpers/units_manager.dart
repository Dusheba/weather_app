import 'package:shared_preferences/shared_preferences.dart';

class Units {
  int t;
  int s;
  int p;
  Units(
      {
        required this.t,
        required this.s,
        required this.p
      }
        );


  String getTemperatureUnit() {
    if(t == 0){
      return '˚C';
    } else {
      return '˚F';
    }
  }

  String getTemperatureValue(int temperature) {
    if(t == 0) {
      return temperature.toString();
    } else{
      return (temperature * 9/5 + 32).toString();
    }
  }

  String getSpeedUnit() {
    if(s == 0) {
      return 'м/с';
    } else {
      return 'км/ч';
    }
  }

  String getSpeedValue(int speed) {
    if(s == 0) {
      return speed.toString();
    } else {
      return (speed * 3.6).toString();
    }
  }

  String getPressureUnit() {
    if(p == 0) {
      return 'мм.рт.ст';
    } else {
      return 'гПа';
    }
  }

  String getPressureValue(int pressure) {
    if(p == 0) {
      return pressure.toString();
    } else {
      return (pressure * 1.33).toStringAsFixed(2);
    }
  }

  void updateValues() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    t = pref.getInt('temp') ?? 0;
    s = pref.getInt('speed') ?? 0;
    p = pref.getInt('pressure') ?? 0;
  }
}