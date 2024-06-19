import 'package:flutter/material.dart';
import 'package:odia_bhagabata/global.dart';
import 'package:odia_bhagabata/pages/homePage.dart';


void main() {
  runApp(MyApp());
}



class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: HomePage(toggleTheme: _toggleTheme),
    );
  }
}





