import 'package:flutter/material.dart';
import 'screens/request_posting_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disaster Relief App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RequestPostingScreen(),
    );
  }
}
