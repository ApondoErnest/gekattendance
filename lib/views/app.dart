import 'package:flutter/material.dart';
import 'package:gekattendance/models/user.dart';
import 'package:gekattendance/providers/user_provider.dart';
import 'package:gekattendance/services/navigation_service.dart';
import 'package:gekattendance/theme.dart';
import 'package:gekattendance/utils/common.dart';
import 'package:gekattendance/views/screens/dashboard_incomplete.dart';
import 'package:gekattendance/views/screens/face_registration_screen.dart';
import 'package:gekattendance/views/screens/login_complete_screen.dart';
import 'package:gekattendance/views/screens/login_screen.dart';
import 'package:gekattendance/views/screens/matricule_register_complete.dart';
import 'package:gekattendance/views/screens/student_dashboard.dart';
import 'package:gekattendance/views/screens/student_registration.dart';
import 'package:gekattendance/views/screens/teacher_attendance_page.dart';
import 'package:gekattendance/views/screens/teacher_dashboard.dart';
import 'package:gekattendance/views/screens/teacher_signup.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getAccessToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: Text('An error occurred')),
            ),
          );
        }

        String token = snapshot.data ?? '';

        return ChangeNotifierProvider(
          create: (context) => UserProvider(),
          child: Builder(
            builder: (context) {
              if (token.isNotEmpty) {
                // Delay setUser call until after first build
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  UserProvider userProvider =
                      Provider.of<UserProvider>(context, listen: false);
                  User user = getUserFromToken(token);
                  userProvider.setUser(user);
                });
              }

              return MaterialApp(
                title: 'AI Class Attendance System',
                theme: AppThemes.lightTheme,
                darkTheme: AppThemes.darkTheme,
                themeMode: ThemeMode.dark,
                initialRoute: token.isEmpty
                    ? '/auth/login'
                    : determineStartRoute(getUserFromToken(token)),
                routes: {
                  '/auth/login': (context) => LoginPage(),
                  '/student/dashboard/incomplete': (context) =>
                      DashboardIncompletePage(),
                  '/auth/register/matricule': (context) =>
                      MatriculeRegisterCompletePage(),
                  '/teacher_signup': (context) => TeacherSignup(),
                  '/teacher/dashboard': (context) => TeacherDashboardPage(),
                  '/student_registration': (context) =>
                      StudentRegistrationPage(),
                  '/student/dashboard': (context) => StudentDashboard(),
                  '/student/register/face': (context) => FaceRegistrationPage()
                },
                onGenerateRoute: (settings) {
                  if (settings.name == '/auth/login/complete') {
                    final String data = settings.arguments as String;
                    return MaterialPageRoute(
                      builder: (context) => LoginCompletePage(email: data),
                    );
                  } else if (settings.name == '/teacher/attendance') {
                    final String data = settings.arguments as String;
                    return MaterialPageRoute(
                      builder: (context) =>
                          TeacherAttendancePage(courseCode: data),
                    );
                  }
                  return null;
                },
              );
            },
          ),
        );
      },
    );
  }
}
