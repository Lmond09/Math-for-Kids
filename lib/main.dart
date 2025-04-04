import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(MathApp());
}

class MathApp extends StatelessWidget {
  const MathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math for Kids',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
      debugShowCheckedModeBanner: false
    );
  }
}
