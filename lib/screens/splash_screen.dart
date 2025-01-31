import 'package:flutter/material.dart';
import 'homepage.dart'; // Import the homepage

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for 3 seconds and then navigate to HomePage
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent, // Background color
      body: Center(
        child: Image.asset(
          'assets/images/logo.png', // Ensure logo is in the assets folder
          height: 150, // Adjust size as needed
        ),
      ),
    );
  }
}
