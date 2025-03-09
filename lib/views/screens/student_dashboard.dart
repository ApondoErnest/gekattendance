import 'package:flutter/material.dart';
import 'package:gekattendance/widgets/common/header.dart';
import 'package:gekattendance/widgets/common/navigation_drawer.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(onMenuTap: () {}),
      drawer: CustomNavigationDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Congratulations on successfully registering for the AI Class Attendance System! We are excited to have you on board.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            _buildSectionTitle('Getting Started'),
            _buildInstruction('Viewing Your Attendance',
                'Navigate to the Attendance section in your dashboard to see your records in a calendar or list view.'),
            _buildInstruction('Marking Attendance',
                'Attendance is recorded automatically using facial recognition when you enter the classroom. Ensure your face is visible to the camera.'),
            _buildInstruction('Checking Attendance History',
                'Visit the History tab to see your attendance breakdown over the semester. Filter by date or courses.'),
            _buildInstruction('Notifications & Alerts',
                'You will receive alerts if you are marked absent when you attended. Contact the course administrator if there are discrepancies.'),
            _buildInstruction('Profile & Settings',
                'Update your profile picture for accurate attendance tracking. Review and update your personal details.'),
            SizedBox(height: 20),
            _buildSectionTitle('Need Help?'),
            Text(
              'If you experience any issues or have questions, contact our support team through the Help & Support section in your dashboard.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInstruction(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text(
            description,
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
