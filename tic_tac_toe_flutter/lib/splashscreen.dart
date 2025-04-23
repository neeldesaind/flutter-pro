import 'dart:async';
import 'package:flutter/material.dart';
import 'homepage.dart'; // Import the file where TicTacToeBoard is defined

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the main game screen after a certain duration
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => TicTacToeBoard(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3E7DB), // Set splash screen background color to #F3E7DB
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/temp.jpeg', // Path to your logo image asset
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20), // Add some space between the logo and progress bar
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator( // Add circular progress indicator
                strokeWidth: 5, // Set thickness of the progress bar
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Color of the progress bar
              ),
            ),
            SizedBox(height: 20), // Add some space between the progress bar and text
            Text(
              'Welcome...', // Add loading text
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10), // Add some space between the loading text and main text
            Text(
              'Tic Tac Toe',
              style: TextStyle(
                fontSize: 24,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
