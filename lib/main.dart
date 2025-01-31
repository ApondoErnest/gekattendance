import 'package:flutter/material.dart';
import 'screens/homepage.dart';
import 'screens/splash_screen.dart';
import 'screens/teacher_signup.dart';
import 'screens/student_registration.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Attendance System',
      theme: ThemeData(
        // Define the default font for the entire app
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Rale way'),
          bodyMedium: TextStyle(fontFamily: 'Rale way'),
        ),
        appBarTheme: AppBarTheme(
          // Set the Simonetta font for the AppBar
          titleTextStyle: TextStyle(
            fontFamily: 'Simonetta',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          // Set the Simonetta font for the footer (if applicable)
          selectedLabelStyle: TextStyle(
            fontFamily: 'Simonetta',
            fontSize: 16,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Simonetta',
            fontSize: 14,
          ),
        ),
      ),
      home: SplashScreen(), // Start with the splash screen,
      routes: {
        '/teacher_signup': (context) => TeacherSignup(),
        '/student_registration': (context) => StudentRegistrationPage(),
      },
    );
  }
}
