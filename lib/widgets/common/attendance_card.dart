import 'package:flutter/material.dart';

class AttendanceCard extends StatelessWidget {
  final DateTime date;
  final int present;
  final int absent;

  const AttendanceCard(
      {required this.date, required this.present, required this.absent});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${date.day}-${date.month}-${date.year}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Present: $present",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Theme.of(context).primaryColor)),
                Text("Absent: $absent",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.redAccent)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
