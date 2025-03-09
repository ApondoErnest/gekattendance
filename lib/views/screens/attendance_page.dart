import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../database/database_helper.dart';

class AttendancePage extends StatefulWidget {
  final String teacherName;
  AttendancePage({required this.teacherName});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  File? _video;
  List<Map<String, String>> presentStudents = [];

  Future<void> _pickVideo() async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _video = File(pickedFile.path);
      });
    }
  }

  void _makeAttendance() async {
    if (_video != null) {
      await DatabaseHelper.instance.saveVideo(_video!.path);
      setState(() {
        presentStudents = [
          {'name': 'Alice Johnson', 'matricule': 'STU1234'},
          {'name': 'Bob Smith', 'matricule': 'STU5678'}
        ];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attendance marked successfully!')),
      );
    }
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        leading: PopupMenuButton<String>(
          icon: Icon(Icons.menu, color: Colors.white),
          onSelected: (value) {
            if (value == 'logout') {
              _logout();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Text('Logged in: ${widget.teacherName}', style: TextStyle(fontWeight: FontWeight.bold)),
              enabled: false,
            ),
            PopupMenuItem(
              value: 'logout',
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text('Logout', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text('Capture Video for Attendance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            SizedBox(height: 10),
            _video == null
                ? Text('No video captured.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey))
                : Text('Video ready for processing', style: TextStyle(fontSize: 16, color: Colors.green)),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickVideo,
              icon: Icon(Icons.videocam),
              label: Text('Capture Video', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _video != null ? _makeAttendance : null,
              child: Text('Make Attendance',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _video != null ? Colors.green : Colors.grey,
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              ),
            ),
            SizedBox(height: 30),
            Text('Present Students', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: presentStudents.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(presentStudents[index]['name']!,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    subtitle: Text('Matricule: ${presentStudents[index]['matricule']}',
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                    leading: Icon(Icons.check_circle, color: Colors.green),
                  );
                },
              ),
            ),
          ],
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
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
