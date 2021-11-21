import 'package:flutter_app/helpers/forecast_manager.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:http/http.dart' as http;
import '../helpers/duration_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

String cityName = "Saint Petersburg";
String lat = "59.931";
String lon = "30.360";
final cities  = <City>[];

class CitySearch extends StatefulWidget {
  const CitySearch({Key? key}) : super(key: key);

  @override
  State<CitySearch> createState() => _CitySearchState();
}

class _CitySearchState extends State<CitySearch> {

  final _controller = TextEditingController();
  final myTimer = DurationManager(milliseconds: 1000);

  List<City> getCities(String resp) {
    final res = jsonDecode(resp).cast<Map<String, dynamic>>();
    return res.map<City>((json) => City.fromJson(json)).toList();
  }

  Future<List<City>> getCity(String str) async {
    final response = await http.get(
        Uri.parse(
            'http://api.openweathermap.org/geo/1.0/direct?q=$str&limit=10&appid=5afa0f095e31e5b72e0d15b4c0dbeed4'
        )
    );
    if (response.statusCode == 200) {
      return getCities(response.body);
    } else {
      throw Exception(
          'Error of loading data. Please, try again'
      );
    }
  }
  void takeCity(String str) async {
    var list = await getCity(str);
    setState(() {
      cities.clear();
      cities.addAll(list);
    }
    );
  }

  Future<void> homeCity(City c) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var cityJson = jsonEncode(c.toJson());
    await pref.setString('main_city', cityJson);
  }

  Future<void> saveCity(City c) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var list = await pref.getStringList('favourites') ?? [];
    list.add(jsonEncode(c.toJson()));
    await pref.setStringList(
        'favourites',
        list
    );
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      backgroundColor: Theme.of(c).colorScheme.secondary,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                    onPressed: (){
                      Navigator.push(c, MaterialPageRoute(builder: (_) => const MainPage())
                      );
                     },
                    child: const Icon(Icons.arrow_back_ios),
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      elevation: 0,
                      onPrimary: Theme.of(c).colorScheme.surface,
                      primary: Theme.of(c).colorScheme.secondary,
                  )
                ),
                Container(
                  height: 50,
                  width: 250,
                child:
                  TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Введите название города...',
                      hintStyle: TextStyle(
                          color: Theme.of(c).textTheme.headline3!.color,
                          fontSize: 15
                      ),
                    ),
                    showCursor: true,
                    cursorColor: Colors.black,
                    style: TextStyle(
                      color: Theme.of(c).colorScheme.surface,
                      fontSize: 13
                    ),
                    textInputAction: TextInputAction.search,
                    onChanged: (i) {
                      myTimer.run(takeCity, i);
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: (){
                    _controller.clear();
                  },
                  child: const Icon(Icons.clear),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    elevation: 0,
                    onPrimary: const Color.fromRGBO(50, 50, 50, 1.0),
                    primary: const Color.fromRGBO(226, 235, 255, 1.0),
                  ),
                )
              ],
            ),
          ),
          Container(
            constraints: BoxConstraints(
                minHeight: 10,
                maxHeight: MediaQuery.of(c).size.height / 3
            ),
              child: ListView.separated(
                itemCount: cities.length,
                itemBuilder: (BuildContext cont, int val){
                  return Container(
                    width: MediaQuery.of(cont).size.width - 30,
                    padding: const EdgeInsets.only(left: 20),
                    alignment: Alignment.topLeft,
                    height: 25,
                    child: Row (
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 5,
                            child:
                                //жест??
                            GestureDetector(
                              onTap: () => {
                                homeCity(cities[val]).
                                then((value) =>
                                    Navigator.push(cont, MaterialPageRoute(builder: (_) => MainPage()
                                        )
                                    )
                                )
                              },
                              child: Text(
                                cities[val].cityName.toString(),
                                style: TextStyle(
                                  color: Theme.of(cont).primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 20),
                          alignment: Alignment.centerRight,
                          child: StarButton(
                            iconSize: 30,
                            iconColor: Theme.of(cont).primaryColor,
                            valueChanged: (is_Favorite) {
                              saveCity(cities[val]).then((value) => null);
                            },
                          ),
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, position) {
                  return Divider();
                },
              ),
          ),
        ],
      ),
    );
  }

  @override
  void initState(){
    super.initState();
  }

}