import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gekattendance/api/institution.dart';
import 'package:gekattendance/widgets/common/attendance_card.dart';
import 'package:gekattendance/widgets/common/header.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';

class TeacherAttendancePage extends StatefulWidget {
  final String courseCode;

  const TeacherAttendancePage({required this.courseCode});

  @override
  _TeacherAttendancePageState createState() => _TeacherAttendancePageState();
}

class _TeacherAttendancePageState extends State<TeacherAttendancePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  bool isLoadingCourseAttendance = true;

  @override
  void initState() {
    super.initState();
    _getCourseAttendance();
  }

  void _getCourseAttendance() async {
    try {
      List<dynamic> attendance = await getCourseAttendance(widget.courseCode);
      setState(() {
        // courses = _courses;
      });
    } finally {
      setState(() {
        isLoadingCourseAttendance = false;
      });
    }
  }

  // Sample attendance records
  final List<Map<String, dynamic>> attendanceRecords = [
    {"date": DateTime(2024, 3, 1), "present": 25, "absent": 5},
    {"date": DateTime(2024, 3, 5), "present": 22, "absent": 8},
    {"date": DateTime(2024, 3, 10), "present": 27, "absent": 3},
  ];

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      File file = File(video.path);
      await initiateAttendance(video, widget.courseCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
          onMenuTap: () {
            Navigator.pop(context);
          },
          icon: Icons.arrow_back,
          action: 'back',
          role: 'teacher'),
      body: Column(
        children: [
          Text(
            'Course - ${widget.courseCode}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          // Calendar widget
          TableCalendar(
            focusedDay: DateTime.now(),
            firstDay: DateTime(2023, 1, 1),
            lastDay: DateTime(2030, 12, 31),
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
          ),

          SizedBox(height: 10),

          // Attendance Cards
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: attendanceRecords.length,
              itemBuilder: (context, index) {
                var record = attendanceRecords[index];
                return AttendanceCard(
                  date: record["date"],
                  present: record["present"],
                  absent: record["absent"],
                );
              },
            ),
          ),
        ],
      ),

      // Fixed Take Attendance Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _pickVideo,
        label: Text("Take Attendance",
            style: Theme.of(context).textTheme.bodyMedium),
        icon: Icon(Icons.check_circle),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
