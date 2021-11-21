import 'package:flutter_app/helpers/forecast_manager.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class SelectedCities extends StatefulWidget {
  const SelectedCities({Key? key}) : super(key: key);

  @override
  State<SelectedCities> createState() => _SelectedCitiesState();
}

class _SelectedCitiesState extends State<SelectedCities> {
  List<City> selCity = [];
  Future<void> initSelected() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var sel = pref.getStringList('favourites');
    setState(() {
      for (String s in sel!){
        var jsonDec = jsonDecode(s);
        selCity.add(
            City(
                name: jsonDec['name'],
                cityName: jsonDec['local_names'],
                lat: jsonDec['lat'],
                lon: jsonDec['lon']
            )
        );
      }
    }
    );
  }

  Future<void> mainCity(City city) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var jsonCity = jsonEncode(city.toJson());
    await pref.setString('main_city', jsonCity);
  }

  Future<void> deleteFavCity(City city) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var sel = pref.getStringList('favourites');
    for (int i = 0; i < sel!.length; i++){
      var decode = jsonDecode(sel[i]);
      if(city.lat == decode['lat'] && city.lon == decode['lon']){
        sel.removeAt(i);
        break;
      }
    }
    await pref.setStringList('favourites', sel);
    setState(() {
      selCity.remove(city);
    }
    );
  }

  @override
  void initState(){
    initSelected().then((value) => {});
    super.initState();
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
        backgroundColor: Theme.of(c).colorScheme.secondary,
        appBar: AppBar(
          backgroundColor: Theme.of(c).colorScheme.secondary,
          elevation: 0,
          leading: ElevatedButton(
            onPressed: (){
              Navigator.push(c, MaterialPageRoute(builder: (_) => MainPage())
              );
            },
            child: Icon(Icons.arrow_back_ios),
            style: ElevatedButton.styleFrom(
                primary: Theme.of(c).colorScheme.secondary,
                onPrimary: Theme.of(c).colorScheme.surface,
                elevation: 0
            ),
          ),
          title: Row(
            children: [
              Container(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                    'Избранное',
                    style: TextStyle(
                        color: Theme.of(c).primaryColor)
                    ,)
              ),
            ],
          ),
          titleTextStyle: TextStyle(
              fontSize: 20,
              color: Theme.of(c).primaryColor,
              fontWeight: FontWeight.bold
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              color: Theme.of(c).colorScheme.secondary
          ),
          child: Container(
              margin: const EdgeInsets.fromLTRB(20, 32, 20, 0),
              child: getFavCity(
                  selCity,
                  Theme.of(c).colorScheme.brightness
              )
          ),
        )
    );
  }

  ListView getFavCity(List<City> city, Brightness br) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: city.length,
        itemBuilder: (BuildContext c, int i) {
          //для светлой темы
          if (br == Brightness.light) {
            return
              Container(
                  width: 320,
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(222, 233, 255, 1.0),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.05),
                            offset: Offset(0, 4),
                            spreadRadius: 5,
                            blurRadius: 4
                        )
                      ]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap:  () => {
                            Navigator.push(c, MaterialPageRoute(builder: (_) => MainPage())
                            ),
                            mainCity(city[i])
                          },
                          child:
                          Container(
                            margin: const EdgeInsets.only(left: 16, right: 20),
                            child: Text(
                              city[i].cityName.toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          )
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(200, 218, 255, 1.0),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Center(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: const Color.fromRGBO(200, 218, 255, 1.0)),
                              onPressed: () {
                                deleteFavCity(city[i]);
                                setState(() {
                                }
                                );
                              },
                              child: Image.asset('images/close.png')
                          ),
                        ),
                      ),
                    ],
                  )
              );
          }
          //для темной темы
          else {
            return
              Container(
                  width: 320,
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(13, 23, 43, 1.0),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.13),
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                            blurRadius: 5
                        ),
                        BoxShadow(
                            color: Color.fromRGBO(255, 255, 255, 0.2),
                            offset: Offset(0, -4),
                            blurRadius: 10
                        )
                      ]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap:  () => {
                            Navigator.push(c, MaterialPageRoute(builder: (_) => MainPage())),
                            mainCity(city[i])
                          },
                          child:
                          Container(
                            margin: const EdgeInsets.only(left: 16),
                            child: Text(
                              city[i].cityName.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          )
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(21, 42, 83, 1.0),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Center(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: const Color.fromRGBO(21, 42, 83, 1.0)),
                              onPressed: () {
                                deleteFavCity(city[i]);
                                setState(() {
                                }
                                );
                              },
                              child: Image.asset('images/close_dark.png')
                          ),
                        ),
                      ),
                    ],
                  )
              );
          }
        }
    );
  }
}