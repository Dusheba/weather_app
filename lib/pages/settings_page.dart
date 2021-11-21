import 'package:flutter_app/pages/main.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter_app/helpers/theme_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int th = 0;
  int s = 0;
  int t = 0;
  int p = 0;

  @override
  void initState(){
    super.initState();
    initValues().then((value) => null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
    appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            elevation: 0,
            leading: ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) => const MainPage())
              );
            },
            child: const Icon(Icons.arrow_back_ios),
              style: ElevatedButton.styleFrom(
              primary: Theme.of(context).colorScheme.secondary,
              onPrimary: Theme.of(context).colorScheme.surface,
              elevation: 0
            ),
            ),
    title: Row(
    children: const [
      Text(
          'Настройки',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w600,
          )
      ),
      ],
    ),
    titleTextStyle: TextStyle(
        fontSize: 20,
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold
    ),
    ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15, top: 35),
            child: Text(
              'Единицы измерения',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).shadowColor,
                  offset: const Offset(0, 4),
                  blurRadius: 10
                ),
                BoxShadow(
                  color: Theme.of(context).cardColor,
                  offset: const Offset(0, -4),
                  blurRadius: 4
                )
              ]
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 20, 0, 16),
                      width: 95,
                      child: const Text(
                        'Тема',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    Container(
                      height: 55,
                      padding: const EdgeInsets.fromLTRB(107, 13, 20, 13),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(30.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  offset: const Offset(4, 4),
                                  blurRadius: 6,
                                  spreadRadius: 0
                              ),
                              BoxShadow(
                                color: Theme.of(context).cardColor,
                                offset: const Offset(-2, -3),
                                blurRadius: 3,
                                spreadRadius: 0,
                              )
                            ]
                        ),
                        child: ToggleSwitch(
                          initialLabelIndex: th,
                          totalSwitches: 2,
                          labels: const ['тёмная', 'светлая'],
                          onToggle: (i) {
                            setState(() {
                              th = i;
                              setTheme();
                              currentTheme.toggleTheme();
                            }
                            );
                          },
                          minHeight: 25,
                          cornerRadius: 30,
                          fontSize: 12,
                          activeFgColor: Theme.of(context).textTheme.headline4!.color,
                          activeBgColor: [Theme.of(context).colorScheme.error],
                          inactiveFgColor: Theme.of(context).textTheme.headline2!.color ,
                          inactiveBgColor: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: CustomPaint(
                    painter: PainterCustom(Theme.of(context).shadowColor),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 20, 0, 16),
                      width: 95,
                      child: Text(
                        'Температура',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor
                        ),
                      ),
                    ),
                  Container(
                    height: 55,
                    padding: const EdgeInsets.fromLTRB(107, 13, 20, 13),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(30.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context).shadowColor,
                                offset: const Offset(4, 4),
                                blurRadius: 6,
                                spreadRadius: 0
                            ),
                            BoxShadow(
                              color: Theme.of(context).cardColor,
                              offset: const Offset(-2, -3),
                              blurRadius: 3,
                              spreadRadius: 0,
                            )
                          ]
                      ),
                      child: ToggleSwitch(
                          initialLabelIndex: t,
                          totalSwitches: 2,
                          labels: const ['˚C', '˚F'],
                          onToggle: (i) {
                            t = i;
                            setTemperature();
                            initValues();
                        },
                        minHeight: 25,
                        activeBgColor: [Theme.of(context).colorScheme.error],
                        activeFgColor: Theme.of(context).textTheme.headline4!.color,
                        inactiveBgColor: Theme.of(context).colorScheme.background,
                        inactiveFgColor: Theme.of(context).textTheme.headline2!.color ,
                        cornerRadius: 30,
                        fontSize: 12,
                      ),
                    ),
                  )
                  ],
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: CustomPaint(
                    painter: PainterCustom(Theme.of(context).shadowColor),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 20, 0, 16),
                      width: 95,
                      child: Text(
                        'Сила ветра',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor
                        ),
                      ),
                    ),
                    Container(
                      height: 55,
                      padding: const EdgeInsets.fromLTRB(107, 13, 20, 13),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(30.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  offset: const Offset(4, 4),
                                  blurRadius: 6,
                                  spreadRadius: 0
                              ),
                              BoxShadow(
                                color: Theme.of(context).cardColor,
                                offset: const Offset(-2, -3),
                                blurRadius: 3,
                                spreadRadius: 0,
                              )
                            ]
                        ),
                        child: ToggleSwitch(
                          initialLabelIndex: s,
                          totalSwitches: 2,
                          labels: const ['м/с', 'км/ч'],
                          onToggle: (index) {
                            s = index;
                            setSpeed();
                            initValues();
                          },
                          cornerRadius: 30,
                          fontSize: 12,
                          minHeight: 25,
                          inactiveBgColor: Theme.of(context).colorScheme.background,
                          inactiveFgColor: Theme.of(context).textTheme.headline2!.color ,
                          activeBgColor: [Theme.of(context).colorScheme.error],
                          activeFgColor: Theme.of(context).textTheme.headline4!.color,
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: CustomPaint(
                    painter: PainterCustom(Theme.of(context).shadowColor),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 20, 0, 16),
                      width: 95,
                      child: const Text(
                        'Давление',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    Container(
                      height: 55,
                      padding: const EdgeInsets.fromLTRB(107, 13, 20, 13),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(30.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  offset: const Offset(4, 4),
                                  blurRadius: 6,
                                  spreadRadius: 0
                              ),
                              BoxShadow(
                                color: Theme.of(context).cardColor,
                                offset: const Offset(-2, -3),
                                blurRadius: 3,
                                spreadRadius: 0,
                              )
                            ]
                        ),
                        child: ToggleSwitch(
                          initialLabelIndex: p,
                          totalSwitches: 2,
                          labels: const ['мм.рт.ст.', 'гПа'],
                          onToggle: (i) {
                            setState(() {
                              p = i;
                              setPressure();
                            });
                          },
                          cornerRadius: 30,
                          fontSize: 12,
                          minHeight: 25,
                          inactiveBgColor: Theme.of(context).colorScheme.background,
                          inactiveFgColor: Theme.of(context).textTheme.headline2!.color,
                          activeBgColor: [Theme.of(context).colorScheme.error],
                          activeFgColor: Theme.of(context).textTheme.headline4!.color,
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
    );
  }

  int returnInitial(Brightness br) {
    if(br == Brightness.dark){
      return 0;
    }
    return 1;
  }

  void setTheme() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('theme', th);
  }

  void setSpeed() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('speed', s);
  }

  void setTemperature() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('temp', t);
  }

  void setPressure() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('pressure', p);
  }

  Future<void> initValues() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      t = preferences.getInt('temp')?? 0;
      p = preferences.getInt('pressure')?? 0;
      s = preferences.getInt('speed')?? 0;
      th = preferences.getInt('theme')?? 0;
    }
    );
  }
}


  class PainterCustom extends CustomPainter {
  Color color = Colors.white;
  PainterCustom(this.color);

  @override
  bool shouldRepaint(CustomPainter painter) {
    return false;
  }

  @override
  void paint(Canvas c, Size s) {
    final fin1 = Offset(20, 0);
    final fin2 = Offset(360, 0);
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    c.drawLine(fin1, fin2, paint);
  }
}
