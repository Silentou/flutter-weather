import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/models/constants.dart';
import 'package:weather/ui/get_started.dart';

void main(){

  runApp(const MyApp(title: 'Weather',));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Constants().primaryColor));
    return const MaterialApp(
      title: 'Weather App',
      home: GetStarted(),
      debugShowCheckedModeBanner: false,
    );
  }
}
