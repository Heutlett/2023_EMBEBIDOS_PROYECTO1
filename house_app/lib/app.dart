import 'package:flutter/material.dart';
import 'package:house_app/screens/diagram.dart';
import 'package:house_app/screens/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      initialRoute: "/",
      routes: {
        "/": (BuildContext context) => const HomePage(),
        "/diagram": (BuildContext context) => const DiagramScreen(),
      },
    );
  }
}
