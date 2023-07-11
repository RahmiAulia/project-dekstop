import 'package:admin/screens/login.dart';
import 'package:admin/screens/page/BahanScreen.dart';
import 'package:admin/screens/page/LaporanScreen.dart';
import 'package:admin/screens/page/member/MemberScreen.dart';
import 'package:admin/screens/page/paket/PaketScreen.dart';
import 'package:admin/screens/page/transaksi/TransaksiScreen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppDrawer extends StatelessWidget {
  final Function(String) changeTitle;

  const AppDrawer({
    Key? key,
    required this.changeTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(child: Image.asset("assets/images/logo2.png")),
            DrawerList(
              title: "Dashboard",
              svgSrc: "assets/icons/menu_dashbord.svg",
              press: () {
                changeTitle("Dashboard");
                Navigator.pop(context);
              },
            ),
            DrawerList(
              title: "Transaksi",
              svgSrc: "assets/icons/menu_tran.svg",
              press: () {
                changeTitle("Transaksi");
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TransaksiScreen()),
                );
              },
            ),
            DrawerList(
              title: "Member",
              svgSrc: "assets/icons/menu_profile.svg",
              press: () {
                changeTitle("Member");
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MemberScreen()),
                );
              },
            ),
            DrawerList(
              title: "Paket",
              svgSrc: "assets/icons/menu_dashbord.svg",
              press: () {
                changeTitle("Paket");
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaketScreen()),
                );
              },
            ),
            DrawerList(
              title: "Bahan",
              svgSrc: "assets/icons/menu_dashbord.svg",
              press: () {
                changeTitle("Bahan");
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BahanScreen()),
                );
              },
            ),
            DrawerList(
              title: "Laporan",
              svgSrc: "assets/icons/menu_dashbord.svg",
              press: () {
                changeTitle("Laporan");
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LaporanScreen()),
                );
              },
            ),
            DrawerList(
              title: "Logout",
              svgSrc: "assets/icons/menu_setting.svg",
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
                                builder: (context) => LoginScreen(
                                  onLogin: () {},
                                ),
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

class DrawerList extends StatelessWidget {
  const DrawerList({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.white,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
