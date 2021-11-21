import 'package:flutter/material.dart';

class Developer extends StatelessWidget {
  const Developer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: AppBar(
          leading: ElevatedButton(
            onPressed:(){
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: Theme.of(context).colorScheme.secondary,
              onPrimary: Theme.of(context).colorScheme.surface,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 0,
          title: Row(
            children: [
              Container(
                  padding: const EdgeInsets.only(right: 140),
                  child: Text(
                    'О разработчиках',
                    style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor
                    ),
                  )
              ),
            ],
          ),
          titleTextStyle: TextStyle(
              fontSize: 20,
              fontFamily: 'Manrope',
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold
          ),
        ),
      body: Container(
        margin: const EdgeInsets.only(
            top: 134,
            left: 78
        ),
        height: 52,
        width: 224,
        decoration: BoxDecoration(
            color:  Theme.of(context).colorScheme.onSurface,
            boxShadow: customShadows(Theme.of(context).colorScheme.brightness),
            borderRadius: BorderRadius.circular(10),
        ),
          child: Center(
            child: Text(
            'Weather App',
                style: TextStyle(
                  fontSize: 25,
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w800,
                )
            ),
          )
        ),
      bottomSheet: Container(
        color: Theme.of(context).colorScheme.secondary,
        child:
        Container(
          height: 346,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: customBottomShadow(Theme.of(context).colorScheme.brightness),
              color: Theme.of(context).colorScheme.secondary,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                      'by ITMO University',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Manrope',
                        fontSize: 15,
                      )
                  )
              ),
              Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                      'Версия 1.0',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Manrope',
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.onBackground
                      )
                  )
              ),
              Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                      'от 30 сентября 2021',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Manrope',
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w800,
                      )
                  )
              ),
              Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                      'Коля привет',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Manrope',
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.onBackground
                      )
                  )
              ),
              Container(
                  padding: const EdgeInsets.only(top: 230),
                  child: Text(
                      '2021',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                          fontFamily: 'Manrope',
                          color: Theme.of(context).primaryColor
                      ),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<BoxShadow> customBottomShadow (Brightness br){
    if (br == Brightness.dark){
      return  [const BoxShadow(
        spreadRadius: 0,
        blurRadius: 8,
        color: Color.fromRGBO(0, 0, 0, 0.07),
        offset: Offset(0, -6),
      ),
        const BoxShadow(
          color: Color.fromRGBO(255, 255, 255, 0.15),
          blurRadius: 10,
          offset: Offset(0, -4),
        )
      ];
    }
    return [const BoxShadow(
      spreadRadius: 0,
      blurRadius: 28,
      color: Color.fromRGBO(0, 0, 0, 0.1),
      offset: Offset(0, -6),
    )
    ];
  }

  List<BoxShadow> customShadows(Brightness br){
    if (br == Brightness.dark){
        return [const BoxShadow(
          blurRadius: 8,
          spreadRadius: 0,
          color: Color.fromRGBO(0, 0, 0, 0.07),
          offset: Offset(0, 4),
        ),
        const BoxShadow(
          spreadRadius: 0,
          blurRadius: 10,
          color: Color.fromRGBO(255, 255, 255, 0.1),
          offset: Offset(0, 0),
        )
      ];
    }
    return [const BoxShadow(
      blurRadius: 4,
      spreadRadius: 0,
      color: Color.fromRGBO(0, 0, 0, 0.05),
      offset: Offset(0, 4),
    ),
      const BoxShadow(
        spreadRadius: 0,
        blurRadius: 4,
        color: Color.fromRGBO(255, 255, 255, 0.05),
        offset: Offset(0, -4),
      )
    ];
  }
}