import 'package:flutter/material.dart';
import 'package:gekattendance/providers/user_provider.dart';
import 'package:gekattendance/utils/common.dart';
import 'package:provider/provider.dart';

class ToggleSwitch extends StatefulWidget {
  final String startLabel;
  final String endLabel;
  bool isChecked;

  ToggleSwitch(
      {super.key,
      required this.startLabel,
      required this.endLabel,
      this.isChecked = false});

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  late bool _isChecked;
  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(
        widget.startLabel,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(
        width: 10,
      ),
      GestureDetector(
        onTap: () {
          setState(() {
            UserProvider userProvider =
                Provider.of<UserProvider>(context, listen: false);
            if (!_isChecked) {
              if (userProvider.user?.teacher != null) {
                Navigator.pushReplacementNamed(context, '/teacher/dashboard');
                setState(() {
                  _isChecked = !_isChecked;
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "You don't have a teacher profile. Contact Admin!",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.redAccent),
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            } else {
              Navigator.popAndPushNamed(
                  context, determineStartRoute(userProvider.user!));
              setState(() {
                _isChecked = !_isChecked;
              });
            }
          });
        },
        child: Container(
          width: 80,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.grey[300], // Background color
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedAlign(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment:
                    !_isChecked ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor, // Active color
                      borderRadius: BorderRadius.circular(25),
                    )),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        width: 10,
      ),
      Text(
        widget.endLabel,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ]);
  }
}
