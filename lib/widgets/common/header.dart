import 'package:flutter/material.dart';
import 'package:gekattendance/widgets/common/toggle_switch.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuTap;
  IconData? icon;
  String? action;
  String? role;
  bool showIcon;

  Header(
      {Key? key,
      required this.onMenuTap,
      this.icon,
      this.action = 'drawer',
      this.role = 'student',
      this.showIcon = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: showIcon
          ? IconButton(
              icon: Icon(icon ?? Icons.menu),
              onPressed: () {
                if (action == 'drawer') {
                  Scaffold.of(context).openDrawer();
                }
                onMenuTap();
              },
            )
          : Container(),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: ToggleSwitch(
            startLabel: 'Student',
            endLabel: 'Teacher',
            isChecked: role == 'teacher',
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
