import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gekattendance/models/user.dart';
import 'package:gekattendance/providers/user_provider.dart';
import 'package:gekattendance/utils/common.dart';
import 'package:provider/provider.dart';

class NavItemModel {
  final String headerText;
  final String bodyText;
  final String iconPath;
  final VoidCallback onTap;
  NavItemModel(
      {required this.headerText,
      required this.bodyText,
      required this.iconPath,
      required this.onTap});
}

class CustomNavigationDrawer extends StatefulWidget {
  const CustomNavigationDrawer({super.key});

  @override
  State<CustomNavigationDrawer> createState() => _CustomNavigationDrawerState();
}

class _CustomNavigationDrawerState extends State<CustomNavigationDrawer> {
  void _gotoCourses() {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/student/courses');
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final User user = userProvider.user!;
    final List<NavItemModel> navItems = [
      NavItemModel(
          headerText: 'Courses',
          bodyText: 'Your registered courses',
          iconPath: 'assets/icons/book.svg',
          onTap: () {
            _gotoCourses();
          }),
      NavItemModel(
          headerText: 'Contact Us',
          bodyText: 'AI Attendance',
          iconPath: 'assets/icons/headset.svg',
          onTap: () {}),
    ];
    double drawerWidth = MediaQuery.of(context).size.width * 0.8;

    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        child: Container(
          width: drawerWidth,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const SizedBox(
                            height: 32, width: 32, child: Icon(Icons.close)),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: DrawerHeader(
                          child: Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodyMedium,
                      )),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    ...navItems.map((navItem) => _buildNavItem(navItem)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Read Our Privacy Policy',
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.bodySmall),
                      SizedBox(height: 4),
                      Text('Read Our Terms & Conditions',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ListTile(
                    leading: Container(
                      width: 47,
                      height: 41,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: SvgPicture.asset(
                            'assets/icons/logout.svg',
                            color: Colors.white,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    title: Text('Log Out',
                        style: Theme.of(context).textTheme.bodyMedium),
                    onTap: () async {
                      await logout();
                      if (context.mounted) {
                        Navigator.popAndPushNamed(context, '/auth/login');
                      }
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(NavItemModel navItem) {
    return GestureDetector(
      onTap: navItem.onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Container(
              width: 47,
              height: 41,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    navItem.iconPath,
                    color: Colors.black,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 17,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    navItem.headerText,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.start,
                  ),
                  Text(navItem.bodyText,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodySmall)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
