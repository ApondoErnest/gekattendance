import 'package:flutter/material.dart';
import 'package:gekattendance/widgets/common/header.dart';
import 'package:gekattendance/widgets/common/navigation_drawer.dart';

class DashboardIncompletePage extends StatefulWidget {
  @override
  State<DashboardIncompletePage> createState() =>
      _DashboardIncompletePageState();
}

class _DashboardIncompletePageState extends State<DashboardIncompletePage> {
  bool isLearner = true; // Toggle state
  void _gotoRegisterMatricule() {
    Navigator.pushNamed(context, '/auth/register/matricule');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(onMenuTap: () {}),
        drawer: const CustomNavigationDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Registration Warning
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "You have not completed your registration.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ),
              SizedBox(height: 50),
              // "Complete Registration" Button
              ElevatedButton.icon(
                onPressed: () {
                  _gotoRegisterMatricule();
                },
                icon: Icon(Icons.arrow_right, size: 28),
                label: Text(
                  "Complete Registration",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
