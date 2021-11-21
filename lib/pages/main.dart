import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'search_page.dart';
import 'package:flutter_app/helpers/theme_config.dart';
import 'package:flutter_app/helpers/theme_manager.dart';
import 'package:flutter_app/helpers/units_manager.dart';
import 'package:flutter_app/helpers/forecast_manager.dart';
import 'package:flutter_app/pages/developer_page.dart';
import 'package:flutter_app/pages/week_forecast_page.dart';
import 'package:flutter_app/pages/selected_cities_page.dart';
import 'package:flutter_app/pages/settings_page.dart';

Units? units;
City? curCity;
Weather? curWeather;
List<Weather> weatherWeek = [];
List<Weather> weatherToday = [];
String? topLine = units!.getTemperatureValue(curWeather!.current) + units!.getTemperatureUnit();
String? midLine = curWeather!.day;
bool isOpen = false;

void main() {
  initializeDateFormatting('ru', null);
  runApp(const WeatherApp());
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  @override
  void initState() {
    currentTheme.getTheme();
    currentTheme.addListener(() {
      setState(() {}
      );
    })
    ;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: CustomTheme.lightTheme,
      themeMode: currentTheme.currentTheme,
      darkTheme: CustomTheme.darkTheme,
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget? constHeader;
  final GlobalKey<ScaffoldState> _scaf = GlobalKey<ScaffoldState>();

  getData() async {
    await getCity();
    try {
      await getWeatherData(
          curCity!.lat.toString(), curCity!.lon.toString(),
          curCity!.name
      ).then((val) {
        weatherToday = val[1];
        curWeather = val[0];
        getUnits();
        setState(() {
        }
        );
      }
      );
    }
    catch (error) {
      await Future.delayed(const Duration(milliseconds: 500));
      await getData();
    }
  }

  Future<void> getUnits() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pressure = pref.getInt('pressure') ?? 0;
      speed = pref.getInt('speed') ?? 0;
      temperature = pref.getInt('temp') ?? 0;
      units = Units(s: speed, p: pressure, t: temperature);
    }
    );
  }

  Future<void> getCity() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var strCoded = pref.getString('main_city');
    setState(() {
      if (strCoded != null) {
        var strJson = jsonDecode(strCoded);
        curCity = City(
            name: strJson['name'],
            cityName: strJson['local_names'],
            lat: strJson['lat'],
            lon: strJson['lon']);
      } else {
        curCity = City(
            name: "London",
            cityName: "Лондон",
            lat: 51.5085,
            lon: -0.1257
        );
      }
    }
    );
  }

  Widget? getConstHeader(bool isOpen) {
    if (isOpen) {
      constHeader = modalExpended();
    } else {
      constHeader = modalNotExpended();
    }
    return constHeader;
  }

  @override
  void initState() {
    super.initState();
    getCity();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        builder: (BuildContext c, AsyncSnapshot<String> snapshot) {
          Widget child;
          if (curWeather != null) {
            child = Scaffold(
              key: _scaf,
              drawer: Drawer(
                child: Container(
                  color: Theme.of(c).colorScheme.secondary,
                  child: ListView(
                    padding: const EdgeInsets.only(top: 32, right: 95, left: 5),
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Weather App',
                                style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 23,
                                    color: Theme.of(c).primaryColor,
                                    fontWeight: FontWeight.w800,
                                ),
                            ),
                          ],
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(c, MaterialPageRoute(builder: (context) => const Settings()));
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    elevation: 0,
                                   primary: Theme.of(c).colorScheme.secondary,
                                    onPrimary: Theme.of(c).primaryColor,
                                ),
                                child: Wrap(children: const <Widget>[
                                  Icon(Icons.settings_outlined),
                                  Text("  Настройки",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Manrope',
                                        fontWeight: FontWeight.w500,
                                      ),
                                  ),
                                ],
                                ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(c, MaterialPageRoute(builder: (context) => (const SelectedCities())));
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    elevation: 0,
                                    primary: Theme.of(c).colorScheme.secondary,
                                    onPrimary: Theme.of(c).primaryColor,
                                ),
                                child: Wrap(children: const <Widget>[
                                  Icon(Icons.favorite_border),
                                  Text("  Избранное",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Manrope',
                                        fontWeight: FontWeight.w500,
                                      ),
                                  ),
                                ],
                                ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(c, MaterialPageRoute(builder: (context) => const Developer()));
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    elevation: 0,
                                    primary: Theme.of(c).colorScheme.secondary,
                                    onPrimary: Theme.of(c).primaryColor,
                                   ),
                                child: Wrap(children: const <Widget>[
                                  Icon(Icons.account_circle_outlined),
                                  Text("  О приложении",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Manrope',
                                        fontWeight: FontWeight.w500,
                                      ),
                                  ),
                                ],
                                ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //штука снизу
              body: ExpandableBottomSheet(
                //открытый
                onIsExtendedCallback: () => {
                  setState(() {
                    topLine = curCity!.cityName;
                    midLine = units!.getTemperatureValue(curWeather!.current) +
                        units!.getTemperatureUnit();
                    isOpen = true;
                  }
                  )
                },
                //закрытый
                onIsContractedCallback: () => {
                  setState(() {
                    isOpen = false;
                    topLine = units!.getTemperatureValue(curWeather!.current) +
                        units!.getTemperatureUnit();
                    midLine = curWeather!.day;
                  },
                  ),
                },
                enableToggle: true,
                background: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: getBackgroundImg(Theme.of(c).primaryColor),
                      fit: BoxFit.cover,
                    ),
                    ),
                    padding: const EdgeInsets.only(top: 50),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _scaf.currentState!.openDrawer();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(c).colorScheme.primary,
                            onPrimary: Colors.white,
                            shape: const CircleBorder(),
                          ),
                          child: const Icon(
                              Icons.menu,
                              size:20
                          ),
                        ),
                        Column(
                          children:
                            (isOpen == true) //чтоб  менялись местами строчки при отрытии модалки
                            ?
                            <Widget>[Text(
                              topLine!,
                                style: const TextStyle(
                                  fontSize: 20,
                                  letterSpacing: 0.1,
                                  color: Colors.white,
                                ),
                              ),
                            Text(
                              midLine!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 80,
                              ),
                            ),
                            ]
                          :
                            <Widget>[Text(
                              topLine!,
                              style: const TextStyle(
                                  fontSize: 80,
                                  color: Colors.white,
                                  letterSpacing: 0.1,
                              ),
                            ),
                              Text(
                                midLine!,
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                ),
                              ),
                            ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(c, MaterialPageRoute(builder: (_) => CitySearch()));
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              side: const BorderSide(color: Colors.white),
                              primary: Theme.of(c).colorScheme.primary,
                              onPrimary: Colors.white),
                              child: const Icon(Icons.add, size:20),
                        ),
                      ],
                    ),
                ),
                persistentHeader: getConstHeader(isOpen),
                expandableContent: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(c).colorScheme.secondary
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(c).colorScheme.secondary
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 150,
                                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Theme.of(c).colorScheme.onPrimary,
                                        boxShadow: cardBoxShadow(
                                            Theme.of(c).colorScheme.brightness
                                        ),
                                    ),
                                    child: Container(
                                        margin: EdgeInsets.fromLTRB(46, 19, 0, 22),
                                        child: Row(
                                          children: [
                                            bottomImage(
                                                Theme.of(c).colorScheme.brightness, 'thermometer'),
                                            Container(
                                              margin: const EdgeInsets.only(left: 8),
                                              child: Text(
                                                units!.getTemperatureValue(curWeather!.current),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Text(units!.getTemperatureUnit(),
                                                style: TextStyle(
                                                    color: Theme.of(c).colorScheme.onSecondary,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600
                                                ),
                                            ),
                                          ],
                                        ),
                                    ),
                                  ),
                                  Container(
                                    width: 150,
                                    margin: const EdgeInsets.fromLTRB(10, 0, 20, 8),
                                    decoration: BoxDecoration(
                                        boxShadow: cardBoxShadow(Theme.of(c).colorScheme.brightness),
                                        borderRadius: BorderRadius.circular(10),
                                        color: Theme.of(c).colorScheme.onPrimary,
                                    ),
                                    child: Container(
                                        margin: const EdgeInsets.fromLTRB(46, 19, 0, 22),
                                        child: Row(
                                          children: [
                                            bottomImage(Theme.of(c).colorScheme.brightness, 'humidity'),
                                            Container(
                                              margin: const EdgeInsets.only(left: 8),
                                              child: Text(
                                                curWeather!.humidity.toString(),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600
                                                ),
                                              ),
                                            ),
                                            Text('%',
                                                style: TextStyle(
                                                    color: Theme.of(c).colorScheme.onSecondary,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600
                                                ),
                                            ),
                                          ],
                                        ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 150,
                                    margin: const EdgeInsets.fromLTRB(20, 32, 20, 32),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: cardBoxShadow(
                                            Theme.of(c).colorScheme.brightness
                                        ),
                                        color: Theme.of(c).colorScheme.onPrimary,
                                    ),
                                    child: Container(
                                        margin:
                                            const EdgeInsets.fromLTRB(46, 19, 0, 22),
                                        child: Row(
                                          children: [
                                            bottomImage(Theme.of(c).colorScheme.brightness, 'breeze'),
                                            Container(
                                              margin: const EdgeInsets.only(left: 8),
                                              child: Text(
                                                units!.getSpeedValue(curWeather!.wind),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600
                                                ),
                                              ),
                                            ),
                                            Text(units!.getSpeedUnit(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Theme.of(c).colorScheme.onSecondary,
                                                    fontWeight: FontWeight.w600,
                                                ),
                                            ),
                                          ],
                                        ),
                                    ),
                                  ),
                                  Container(
                                    width: 150,
                                    height: 65,
                                    margin: const EdgeInsets.fromLTRB(20, 32, 0, 32),
                                    decoration: BoxDecoration(
                                        color: Theme.of(c).colorScheme.onPrimary,
                                        boxShadow: cardBoxShadow(Theme.of(c).colorScheme.brightness),
                                        borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Row(
                                    children: [
                                      Container(
                                          margin: const EdgeInsets.only(left: 4),
                                          child: bottomImage(Theme.of(c).colorScheme.brightness, 'barometer')
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        child: Text(
                                          units!.getPressureValue(curWeather!.pressure),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Theme.of(c).primaryColor
                                          ),
                                        ),
                                      ),
                                      Text(
                                          units!.getPressureUnit(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(c).colorScheme.onSecondary,
                                              fontWeight: FontWeight.w600
                                          ),
                                      ),
                                    ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ),
              ),
            );
          } else {
            child = Scaffold(
              backgroundColor: Theme.of(c).colorScheme.secondary,
              body: Center(
                  child: Stack(
                children: [
                  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(c).size.height / 4
                      ),
                      child: const Text(
                        'Weather',
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                  ),
                  Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(c).primaryColor,
                    ),
                  )
                ],
              ),
              ),
            );
          }
          return Container(
            child: child,
          );
        }
        );
  }

  Widget modalExpended() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    height: 3,
                    width: 60,
                    image: headerImg(Theme.of(context).colorScheme.brightness),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 20),
              child: Center(
                child: Text(
                  DateFormat.MMMMd('ru').format(DateTime.now()
                  ),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 0.0),
              height: 150.0,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  padding: const EdgeInsets.only(
                      left: 8,
                      top: 0,
                      bottom: 0,
                      right: 8
                  ),
                  itemBuilder: (BuildContext c, int val) {
                    return Container(
                      padding: const EdgeInsets.only(
                          left: 10,
                          top: 15,
                          bottom: 15,
                          right: 10
                      ),
                      margin: const EdgeInsets.only(
                          left: 2,
                          top: 5,
                          bottom: 5,
                          right: 2
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(c).colorScheme.onPrimary,
                        borderRadius: BorderRadius.all(const Radius.circular(18)),
                        boxShadow: cardBoxShadow(Theme.of(c).brightness),
                      ),
                      child: Column(children: [
                        Text(
                          weatherToday[val].time,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Theme.of(c).primaryColor
                          ),
                        ),
                        getForecastIcon(weatherToday[val].image, Theme.of(c).colorScheme.brightness),
                        Text(
                          units!.getTemperatureValue(weatherToday[val].current) + units!.getTemperatureUnit(),
                          style: TextStyle(
                            fontSize: 17,
                            color: Theme.of(c).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ]
                      ),
                    );
                  }
              ),
            ),
          ]
      ),
    );
  }

  Widget modalNotExpended() {
    return Container(
        height: 300,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
            ),
        ),
        child: Column(children: <Widget>[
          Container(
              padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 20
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    height: 3,
                    width: 60,
                    image: headerImg(Theme.of(context).colorScheme.brightness),
                  )
                ],
              ),
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 0.0),
              height: 150.0,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  padding: const EdgeInsets.only(
                      left: 8,
                      top: 0,
                      bottom: 0,
                      right: 8
                  ),
                  itemBuilder: (BuildContext c, int val) {
                    return Container(
                        padding: const EdgeInsets.only(
                            left: 10,
                            top: 15,
                            bottom: 15,
                            right: 10
                        ),
                        margin: const EdgeInsets.only(
                            left: 2,
                            top: 5,
                            bottom: 5,
                            right: 2
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          boxShadow: cardBoxShadow(Theme.of(c).brightness),
                          color: Theme.of(c).colorScheme.onPrimary,
                        ),
                        child: Column(
                            children: [
                          Text(
                            weatherToday[val].time,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                color: Theme.of(c).primaryColor
                            ),
                          ),
                          getForecastIcon(
                              weatherToday[val].image,
                              Theme.of(c).colorScheme.brightness
                          ),
                          Text(
                            units!.getTemperatureValue(weatherToday[val].current) +
                                units!.getTemperatureUnit(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                color: Theme.of(c).primaryColor
                            ),
                          ),
                        ],
                        ),
                    );
                  }
                  ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: Theme.of(context).colorScheme.secondaryVariant)
            ),
            margin: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => WeekForecast()));
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: Theme.of(context).colorScheme.onPrimary,
                ),
                child: Text(
                  'Прогноз на неделю',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondaryVariant,
                      fontSize: 14,
                  ),
                ),
            ),
          ),
        ]
        ),
    );
  }

  AssetImage getBackgroundImg(Color theme) {
    String path = 'images/';
    String img = ".png";
    if (theme == Colors.black) {
      return AssetImage(
          path + 'fon' + img
      );
    } else {
      return AssetImage(
          path + 'fon_dark' + img
      );
    }
  }

  Image bottomImage(Brightness br, String _icon) {
    if (br == Brightness.dark) {
      return Image.asset(
          'images/' + _icon + '_dark.png',
          width: 24,
          height: 24
      );
    }
    return Image.asset(
        'images/' + _icon + '.png',
        width: 24,
        height: 24
    );
  }

  Image getForecastIcon(String _icon, Brightness br) {
    String path = 'images/';
    if (br == Brightness.dark) {
      _icon += '_dark';
    }
    String img = ".png";
    return Image.asset(
      path + _icon + img,
      width: 70,
      height: 70,
    );
  }


  AssetImage headerImg(Brightness br) {
    if (br == Brightness.dark) {
      return const AssetImage('images/header_dark.png');
    }
    return const AssetImage('images/header.png');
  }

  List<BoxShadow> cardBoxShadow(Brightness br) {
    if (br == Brightness.dark) {
      return [
        const BoxShadow(
          offset: Offset(4, 4),
          color: Color.fromRGBO(0, 0, 0, 0.15),
          blurRadius: 6,
          spreadRadius: 0,
        ),
        const BoxShadow(
          offset: Offset(-2, -3),
          blurRadius: 0,
          color: Color.fromRGBO(255, 255, 255, 0.05),
        ),
      ];
    }
    return [
      const BoxShadow(
        offset: Offset(0, 7),
        color: Color.fromRGBO(58, 58, 58, 0.1),
        blurRadius: 20,
        spreadRadius: 0,),
      const BoxShadow(
        offset: Offset(0, -5),
        blurRadius: 9,
        color: Color.fromRGBO(255, 255, 255, 0.25),
      ),
    ];
  }
}
