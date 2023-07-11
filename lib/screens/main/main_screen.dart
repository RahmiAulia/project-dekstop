import 'package:admin/controllers/MenuAppController.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';

import 'package:admin/screens/main/components/side_menu2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  final VoidCallback onLogout;

  MainScreen({required this.onLogout});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
                child: SideMenuNew(
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
