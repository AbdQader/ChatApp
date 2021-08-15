import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {

  static Function theme = (BuildContext context) => ThemeData(
    appBarTheme: AppBarTheme(
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
    ),
    textTheme: ThemeData.light().textTheme.copyWith(
      bodyText1: TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontFamily: 'RobotoCondensed',
        fontWeight: FontWeight.bold,
      ),
      headline1: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        color: Colors.black87,
        fontSize: 15,
      ),
    ),
    primarySwatch: Colors.blue,
    backgroundColor: Colors.pink,
    accentColor: Colors.deepPurple,
    accentColorBrightness: Brightness.dark,
    buttonTheme: ButtonTheme.of(context).copyWith(
      buttonColor: Colors.pink,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )
        ),
      ),
    ),
  );

  // For Light Theme
  static ThemeData lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
    ),
    primarySwatch: Colors.blue,
    accentColor: Colors.blueAccent,
    primaryColor: Colors.grey[100],
    backgroundColor: Colors.white,
    canvasColor: Colors.grey[300],
    buttonColor: Colors.black,
    hintColor: Colors.grey,
    focusColor: Color(0xFF000000),
    cardColor: Colors.grey[300],
    textTheme: ThemeData.light().textTheme.copyWith(
      bodyText1: TextStyle(
        color: Colors.black,
        fontSize: 22,
        fontFamily: 'RobotoCondensed',
        fontWeight: FontWeight.bold,
      ),
      bodyText2: TextStyle(
        color: Colors.black,
        fontSize: 40,
        fontFamily: 'RobotoCondensed',
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0
      ),
      headline1: TextStyle(
        color: Colors.white,
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        color: Colors.black,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        color: Colors.black87,
        fontSize: 16.0,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )
        ),
      ),
    ),
  );

  // For Dark Theme
  static ThemeData darkTheme = ThemeData(
    appBarTheme: AppBarTheme(
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light
      ),
      backgroundColor: Colors.black,
      elevation: 0.0,
    ),
    primarySwatch: Colors.blue,
    accentColor: Colors.blue,
    primaryColor: Color(0xFF191919),
    backgroundColor: Colors.black,
    canvasColor: Colors.white,
    buttonColor: Colors.white,
    hintColor: Colors.grey[800],
    focusColor: Colors.grey,
    cardColor: Colors.grey[900],
    textTheme: ThemeData.dark().textTheme.copyWith(
      bodyText1: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontFamily: 'RobotoCondensed',
        fontWeight: FontWeight.bold,
      ),
      bodyText2: TextStyle(
        color: Colors.white,
        fontSize: 40,
        fontFamily: 'RobotoCondensed',
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0
      ),
      headline1: TextStyle(
        color: Colors.black,
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )
        ),
      ),
    ),
  );

}