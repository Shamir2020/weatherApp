import 'package:flutter/material.dart';
import 'screens/splashScreen.dart';
import 'screens/WeatherScreen.dart';
void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splashScreen',
      routes: {
        '/splashScreen':(context)=>SplashScreen(),
        '/weatherScreen':(context)=>WeatherPage()
      },
    );
  }
}
