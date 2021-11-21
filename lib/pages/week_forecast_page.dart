import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/helpers/units_manager.dart';
import 'package:flutter_app/helpers/forecast_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

String city = "Saint Petersburg";
String lat = "59.931";
String lon = "30.360";
List<Weather> weekForecast = [];
Units? newUnits;
int pressure = 0;
int speed = 0;
int temperature = 0;

class WeekForecast extends StatefulWidget {
  const WeekForecast({Key? key}) : super(key: key);

  @override
  State<WeekForecast> createState() => _WeekForecastState();
}

class _WeekForecastState extends State<WeekForecast> {
  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 1),
        () => 'Forecast was loaded',
  );

  loadData() async{
    getWeatherData(lat, lon, city).then((value){
      weekForecast = value[2];
      getUnits();
      setState(() {
      }
      );
    }
    );
  }
  Future<void> getUnits() async {
    SharedPreferences prew = await SharedPreferences.getInstance();
    setState(() {
      temperature = prew.getInt('temp')?? 0;
      pressure = prew.getInt('pressure')?? 0;
      speed = prew.getInt('speed')?? 0;
      newUnits = Units(t: temperature, s: speed, p: pressure);
      newUnits!.updateValues();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _calculation,
        builder: (BuildContext cont, AsyncSnapshot<String> snapshot) {
          Widget child;
          if (snapshot.hasData) {
            child = Scaffold(
                  backgroundColor: Theme.of(cont).colorScheme.secondary,
                  appBar: AppBar(
                    backgroundColor: Theme.of(cont).colorScheme.secondary,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    title: Container(
                      padding: const EdgeInsets.only(left: 65, top: 34),
                      child: Text(
                        "Прогноз на неделю",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(cont).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  body: Container(
                      child: Column(
                        children: [
                          Container(
                            height: 480,
                            child: Swiper(
                              itemCount: 7,
                              itemBuilder: (BuildContext c, int i) {
                                return Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      height: 387,
                                      margin: const EdgeInsets.fromLTRB(20, 32, 20, 40),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                            colors: GradientWidget(Theme.of(c).colorScheme.brightness),
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                      ),
                                      child: Container(
                                        margin: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              weekForecast[i].day,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(c).primaryColor,
                                                fontSize: 24,
                                              ),
                                            ),
                                            Container(
                                              child: getForecastDailyIcon(weekForecast[i].image),
                                              margin: const EdgeInsets.only(top: 16),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(top: 45),
                                              child: Row(
                                                children: [
                                                  getForecastIcon("thermometer", Theme.of(c).colorScheme.brightness),
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 8),
                                                    child: Text(
                                                      newUnits!.getTemperatureValue(weekForecast[i].current),
                                                      style: TextStyle(
                                                        color: Theme.of(c).primaryColor,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                      newUnits!.getTemperatureUnit(),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w600,
                                                          color: Theme.of(c).textTheme.headline6!.color,
                                                      ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(top: 26),
                                              child: Row(
                                                children: [
                                                  getForecastIcon("breeze", Theme.of(c).colorScheme.brightness),
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 8),
                                                    child: Text(
                                                      newUnits!.getSpeedValue(weekForecast[i].wind),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w600,
                                                          color: Theme.of(c).primaryColor
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                      newUnits!.getSpeedUnit(),
                                                      style: TextStyle(
                                                          color: Theme.of(c).textTheme.headline6!.color,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(top: 26),
                                              child: Row(
                                                children: [
                                                  getForecastIcon("humidity", Theme.of(c).colorScheme.brightness),
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 8),
                                                    child: Text(
                                                      weekForecast[i].humidity.toString(),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w600,
                                                          color: Theme.of(c).primaryColor
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                      '%',
                                                      style: TextStyle(
                                                          color: Theme.of(c).textTheme.headline6!.color,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(top: 26),
                                              child: Row(
                                                children: [
                                                  getForecastIcon("barometer", Theme.of(c).colorScheme.brightness),
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 8),
                                                    child: Text(
                                                      newUnits!.getPressureValue(weekForecast[i].pressure),
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        color: Theme.of(c).primaryColor,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                      newUnits!.getPressureUnit(),
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        color: Theme.of(c).textTheme.headline6!.color,
                                                        fontSize: 16,
                                                      ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Container(
                                    //   margin: const EdgeInsets.only(top: 40),
                                    //   decoration: BoxDecoration(
                                    //       borderRadius: BorderRadius.circular(10),
                                    //       border: Border.all(color: Theme.of(c).primaryColor)
                                    //   ),
                                    //   child:
                                    //   ElevatedButton(
                                    //     onPressed: () {
                                    //     Navigator.of(c).pop();
                                    //   },
                                    //       style: ElevatedButton.styleFrom(
                                    //         elevation: 0,
                                    //         primary: Theme.of(c).colorScheme.onPrimary,
                                    //       ),
                                    //       child: Text(
                                    //         'Вернуться на главную',
                                    //         style: TextStyle(
                                    //             fontSize: 14,
                                    //             color: Theme.of(c).primaryColor
                                    //         ),
                                    //       ),
                                    //   ),
                                    // ),
                                  ],
                                );
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 40),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Theme.of(cont).primaryColor)
                            ),
                            child:
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(cont).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                primary: Theme.of(cont).colorScheme.onPrimary,
                              ),
                              child: Text(
                                'Вернуться на главную',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(cont).primaryColor
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ),
            );
          }
          else {
            child = Scaffold(
              backgroundColor: const Color.fromRGBO(226, 235, 255, 1.0),
              body: Center(
                  child: Stack(
                    children: [
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(bottom: MediaQuery.of(cont).size.height / 4),
                          child: const Text(
                            'Weather',
                            style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w600
                            ),
                          )
                      ),
                      const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      )
                    ],
                  )
              ),
            );
          }
          return Container(
            child: child,
          );
        }
    );
  }

  Image getForecastDailyIcon(String _icon) {
    String imgPath = 'images/';
    String str = ".png";
    return Image.asset(
      imgPath + _icon + str,
      width: 85,
      height: 76,
    );
  }

  Image getForecastIcon(String _icon, Brightness br) {
    String imgPath = 'images/';
    if (br == Brightness.dark){
      _icon += '_dark';
    }
    String str = ".png";
    return Image.asset(
      imgPath + _icon + str,
      width: 24,
      height: 24,
    );
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  List<Color> GradientWidget(Brightness brightness){
    if(brightness == Brightness.dark){
      return const [
        Color.fromRGBO(34, 59, 112, 1.0),
        Color.fromRGBO(15, 31, 64, 1.0)
      ];
    }
    return const [
      Color.fromRGBO(205, 218, 245, 1.0),
      Color.fromRGBO(156, 188, 255, 1.0)
    ];
  }
}