import 'package:flutter/material.dart';

class UiConfig {
  UiConfig._();

  static String get title => 'CuidaPet';

// //Meu tema personalizado
  static ThemeData get theme => ThemeData(
        primaryColor: const Color.fromARGB(255, 0, 233, 249),
        primaryColorDark: const Color.fromARGB(255, 56, 138, 159),
        primaryColorLight: const Color.fromARGB(255, 199, 221, 233),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 75, 169, 206),
        ),
      );

  // //Tema original do curso
  // static ThemeData get theme => ThemeData(
  //       primaryColor: const Color(0xffA8CE4B),
  //       primaryColorDark: const Color(0xff589F38),
  //       primaryColorLight: const Color(0xffDDE9C7),
  //       appBarTheme: const AppBarTheme(
  //         backgroundColor: Color(0xffA8CE4B),
  //       ),
  //     );

}
