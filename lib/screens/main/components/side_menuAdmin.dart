import 'package:admin/screens/components/AppDrawer.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';

import 'package:admin/screens/login.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:admin/screens/page/BahanScreen.dart';
import 'package:admin/screens/page/LaporanScreen.dart';
import 'package:admin/screens/page/member/MemberScreen.dart';
import 'package:admin/screens/page/paket/PaketScreen.dart';

import 'package:admin/screens/page/transaksi/TransaksiScreen.dart';
import 'package:admin/screens/page/transaksi/dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../page/petugas/PetugasScreen.dart';

class SideMenuAdmin extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const SideMenuAdmin({
    Key? key,
    required this.navigatorKey,
  }) : super(key: key);

  @override
  State<SideMenuAdmin> createState() => _SideMenuAdminState();
}

class _SideMenuAdminState extends State<SideMenuAdmin> {
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(child: Image.asset("assets/images/logo2.png")),
            DrawerList(
              title: "Dashboard",
              svgSrc: "assets/icons/bxs-dashboard.svg",
              press: () {
                widget.navigatorKey.currentState!.pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => Dashboard(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
            ),
            DrawerList(
              title: "Paket",
              svgSrc: "assets/icons/bxs-package.svg",
              press: () {
                widget.navigatorKey.currentState!.push(
                  MaterialPageRoute(builder: (context) => PaketScreen()),
                );
              },
            ),
            DrawerList(
              title: "Profit",
              svgSrc: "assets/icons/bx-line-chart.svg",
              press: () {
                widget.navigatorKey.currentState!.push(
                  MaterialPageRoute(builder: (context) => LaporanScreen()),
                );
              },
            ),
            DrawerList(
              title: "Petugas",
              svgSrc: "assets/icons/bxs-user-pin.svg",
              press: () {
                widget.navigatorKey.currentState!.push(
                  MaterialPageRoute(builder: (context) => PetugasScreen()),
                );
              },
            ),
            DrawerList(
              title: "Logout",
              svgSrc: "assets/icons/bx-exit.svg",
              press: () {
                showCupertinoDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title: Text('Konfirmasi Logout'),
                      content: Text('Anda yakin ingin keluar?'),
                      actions: [
                        CupertinoDialogAction(
                          child: Text(
                            'Nanti saja',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        CupertinoDialogAction(
                          child: Text(
                            'Iya',
                            style: TextStyle(color: Colors.green),
                          ),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    LoginScreen(onLogin: () {}),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
