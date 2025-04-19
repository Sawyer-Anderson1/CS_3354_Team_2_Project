// main dart just sends to the homescreen UI 
// sets the theme and calls the homescreen class 
// starting point is homescreen and everything after that will be in the home screen 
// This is what starts it all

import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Import the HomeScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disaster Relief Web App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'ComicSans', // <-- Set the global font here
      ),
      home: const HomeScreen(), // Set HomeScreen as the starting point
    );
  }
}


