import 'package:flutter/material.dart';
import 'package:covid_stats_app/homepage.dart';
import 'package:covid_stats_app/datasource.dart';

void main() {
  runApp(CovidApp());
}

class CovidApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Circular',
        primaryColor: primaryBlack,
      ),
      home: HomePage(),
    );
  }
}
