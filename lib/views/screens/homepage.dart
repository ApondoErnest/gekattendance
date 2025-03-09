import 'package:flutter/material.dart';

import '../../database/database_helper.dart';
import 'attendance_page.dart'; // Ensure this file exists

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final teacher = await DatabaseHelper.instance.getTeacherByEmail(email);

    if (teacher != null && teacher['password'] == password) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Successful!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AttendancePage(teacherName: teacher['name'])),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email or password!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(
          'AI Attendance System',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Simonetta',
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white70,
              Colors.white30,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 140,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Login to Continue',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Raleway',
                        color: Colors.blue.shade300,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email or Username',
                    labelStyle: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 16.0,
                      color: Colors.lightBlueAccent,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    prefixIcon:
                        Icon(Icons.person, color: Colors.lightBlueAccent),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 16.0,
                      color: Colors.lightBlueAccent,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.lightBlueAccent),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: _login,
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                TextButton.icon(
                  icon: Icon(Icons.person_add, color: Colors.blueAccent),
                  label: Text(
                    'Register Student',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 16.0,
                      color: Colors.blueAccent,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/student_registration');
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                ),
                TextButton.icon(
                  icon: Icon(Icons.app_registration, color: Colors.green),
                  label: Text(
                    'Teacher Signup',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 16.0,
                      color: Colors.green,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/teacher_signup');
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Colors.lightBlueAccent.shade100,
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Powered by AI Attendance System',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Simonetta',
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
