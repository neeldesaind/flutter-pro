import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'homepage.dart'; // Import your home page file here

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue, // Set background color to light blue
      body: Stack(
        children: [
          Positioned(
            top: 60, // Adjust this value to control the vertical positioning
            left: 20, // Adjust this value to control the horizontal positioning
            child: Text(
              'Welcome :)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: CurvePainter(),
            ),
          ),
          Center(
            child: _isLoading
                ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), // Adjust sigmaX and sigmaY for blur intensity
              child: Container(
                color: Colors.black.withOpacity(0), // Make container transparent
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/load.gif',
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(height: 10), // Add spacing between image and text
                    Text(
                      'Loading...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/logo.gif',
                  width: 300,
                  height: 300,
                ), // Add spacing to separate the elements
                Text(
                  'SIP & Lumpsum Calculator',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20), // Add spacing to separate the elements
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });
                    Future.delayed(Duration(seconds: 3), () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    });
                  },
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(BorderSide(color: Colors.blue)), // Set border side
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent), // Set transparent background color
                  ),
                  child: Text(
                    'Get Started',
                    style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.white; // Curve color
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.24, size.width * 0.5, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.0, size.height * 0.20, size.width, size.height * 0.2);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
