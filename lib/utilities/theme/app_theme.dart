import 'package:flutter/material.dart';

final _buttonShape = MaterialStateProperty.all(
  const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(30),
    ),
  ),
);

final _buttonStyle = ButtonStyle(
  padding: MaterialStateProperty.all(
    const EdgeInsets.symmetric(
      vertical: 12,
    ),
  ),
  shape: _buttonShape,
);

ThemeData appTheme = ThemeData(
  useMaterial3: false,
  primarySwatch: Colors.indigo,
  fontFamily: 'Quicksand',
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: _buttonStyle,
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(style: _buttonStyle),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    showUnselectedLabels: true,
    selectedItemColor: Colors.indigoAccent,
    selectedLabelStyle: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    unselectedItemColor: Colors.black,
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    },
  ),
);
