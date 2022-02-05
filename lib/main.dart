import 'package:flutter/material.dart';
import 'screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallpaper App',
      home: Scaffold(
        body: Home(),
      ),
    );
  }
}

// 563492ad6f9170000100000171b4ece07a274eda93596b8ab95776b6
