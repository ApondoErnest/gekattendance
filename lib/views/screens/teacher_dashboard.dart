import 'package:flutter/material.dart';
import 'package:gekattendance/api/institution.dart';
import 'package:gekattendance/models/institution.dart';
import 'package:gekattendance/providers/user_provider.dart';
import 'package:gekattendance/widgets/common/header.dart';
import 'package:gekattendance/widgets/course_card.dart';
import 'package:provider/provider.dart';

class TeacherDashboardPage extends StatefulWidget {
  TeacherDashboardPage({super.key});
  @override
  State<TeacherDashboardPage> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboardPage> {
  List<Course> courses = [];
  bool isLoadingCourses = true;

  void gotoAttendance(String code) {
    Navigator.pushNamed(context, '/teacher/attendance', arguments: code);
  }

  @override
  void initState() {
    super.initState();
    _getTeacherCourses();
  }

  void _getTeacherCourses() async {
    try {
      List<Course> _courses = await getTeacherCourses();
      setState(() {
        courses = _courses;
      });
    } finally {
      setState(() {
        isLoadingCourses = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: Header(
        onMenuTap: () {
          Navigator.pop(context);
        },
        icon: Icons.arrow_back,
        action: 'back',
        role: 'teacher', showIcon: false,
      ),
      body: isLoadingCourses
          ? Center(
              child: CircularProgressIndicator()) // Show loader when loading
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: courses.map((course) {
                  return CourseCard(
                    title: course.title,
                    code: course.code,
                    onClick: (code) {
                      gotoAttendance(code);
                    },
                  );
                }).toList(),
              ),
            ),
    );
  }
}
