import 'package:flutter/material.dart';
import 'package:gekattendance/screens/student_registration.dart';
import 'package:gekattendance/screens/teacher_signup.dart';
import 'package:gekattendance/theme.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Class Attendance System',
      theme: AppThemes.lightTheme, // Default Light Theme
      darkTheme: AppThemes.darkTheme, // Dark Theme
      themeMode: ThemeMode.system, // Auto switch based on system setting,
      initialRoute: token.isEmpty ? '/auth/login' : '/home',
      routes: {
        '/auth/login': (context) => LoginPage(),
        '/teacher_signup': (context) => TeacherSignup(),
        '/student_registration': (context) => StudentRegistrationPage(),
      },
    );
  }
}
