import 'package:emaketa/common/models/user.dart';
import 'package:emaketa/common/navigation_service.dart';
import 'package:emaketa/common/providers/user.dart';
import 'package:emaketa/common/utilities.dart';
import 'package:emaketa/view/screens/payment_methods/payment_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
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
  void _gotoPaymentMethods() {
    Navigator.pop(context);
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.leftToRight,
            child: const PaymentMethodsScreen()));
  }

  void _gotoDeliveryAddresses() {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/delivery-addresses');
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final User user = userProvider.user!;
    final List<NavItemModel> navItems = [
      NavItemModel(
          headerText: 'Edit Profile',
          bodyText: 'Update Your Personal Information',
          iconPath: 'assets/icons/person.svg',
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/profile');
          }),
      NavItemModel(
          headerText: 'Payment Methods',
          bodyText: 'Your preferred means of payments',
          iconPath: 'assets/icons/wallet.svg',
          onTap: () {
            _gotoPaymentMethods();
          }),
      NavItemModel(
          headerText: 'Delivery Address',
          bodyText: 'Where your goods would be delivered to',
          iconPath: 'assets/icons/location.svg',
          onTap: _gotoDeliveryAddresses),
      NavItemModel(
          headerText: 'Contact Us',
          bodyText:
              'Need help on how eMaketa works? Learn more from our knowledge base',
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
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0XFFAFD2FF), // Light blue at the top
                Color(0xFFFFFFFF), // Almost white at the bottom
              ],
            ),
          ),
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
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: user.profileImage.isEmpty
                                  ? const AssetImage(
                                      'assets/images/profile-placeholder.png',
                                    )
                                  : NetworkImage(user.profileImage),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.nickName.isNotEmpty
                                      ? '@${user.nickName}'
                                      : user.phoneNumber,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                // Text(
                                //   'gillis@kunshort.com',
                                //   style: Theme.of(context)
                                //       .textTheme
                                //       .bodySmall!
                                //       .copyWith(color: Colors.black),
                                // ),
                                Text(
                                  user.phoneNumber,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: Colors.black),
                                )
                              ],
                            )
                          ])),
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
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Read Our Privacy Policy',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.black54, fontSize: 10),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Read Our Terms & Conditions',
                        style: TextStyle(color: Colors.black54, fontSize: 10),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.black,
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
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.black)),
                    onTap: () async {
                      await logout();
                      if (NavigationService.navigatorKey.currentState != null) {
                        NavigationService.navigatorKey.currentState!
                            .popAndPushNamed('/login', arguments: widget);
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
                  Text(
                    navItem.bodyText,
                    textAlign: TextAlign.left,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
