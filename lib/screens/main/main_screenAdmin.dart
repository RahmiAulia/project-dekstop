import 'package:admin/controllers/MenuAppController.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:admin/screens/main/components/side_menuAdmin.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreenAdmin extends StatefulWidget {
  final VoidCallback onLogout;

  MainScreenAdmin({required this.onLogout});

  @override
  State<MainScreenAdmin> createState() => _MainScreenAdminState();
}

class _MainScreenAdminState extends State<MainScreenAdmin> {
  String status = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStatus();
  }

  Future<void> getStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedStatus = prefs.getString('status');
    setState(() {
      status = storedStatus!;
    });
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenuAdmin(
                  navigatorKey: navigatorKey,
                ),
              ),
            Expanded(
              flex: 5,
              child: Navigator(
                key: navigatorKey,
                onGenerateRoute: (settings) => MaterialPageRoute(
                  settings: settings,
                  builder: (context) => Dashboard(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
