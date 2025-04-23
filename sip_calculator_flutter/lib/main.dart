import 'package:flutter/material.dart';
import 'splash_screen.dart'; // Import your splash screen file here

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Navigate to the splash screen initially
    );
  }
}
