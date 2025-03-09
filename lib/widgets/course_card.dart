import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String code;
  final Function(String) onClick;

  const CourseCard(
      {required this.title, required this.code, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text("Course Code: $code",
            style: const TextStyle(color: Colors.grey)),
        leading: Icon(Icons.book, color: Theme.of(context).primaryColor),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: () => onClick(code),
      ),
    );
  }
}
