import 'package:flutter/material.dart';
import 'splashscreen.dart'; // Import the splash screen widget

void main() {
  runApp(TicTacToeGame());
}

class TicTacToeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white, // Set app's background color to white
      ),
      home: SplashScreen(), // Display splash screen initially
      debugShowCheckedModeBanner: false,
    );
  }
}
