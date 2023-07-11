import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
import 'package:http/http.dart' as http;

class judulAtas extends StatefulWidget {
  const judulAtas({
    Key? key,
  }) : super(key: key);

  @override
  State<judulAtas> createState() => _judulAtasState();
}

class _judulAtasState extends State<judulAtas> {
  int _dataKonsumen = 0;
  int _dataTransaksi = 0;
  int _dataStatus = 0;
  int _dataTotal = 0;
  String username = '';
  @override
  void initState() {
    super.initState();
    getDataKonsumen();
    getDataTransaksi();
    getDataStatus();
    getDataTotal();
  }

  Future<void> getDataKonsumen() async {
    var response =
        await http.get(Uri.parse("$apiUrl/konsumens-banyak"));
    var data = json.decode(response.body);
    var responseData = data['data'];
    if (mounted) {
      setState(() {
        if (responseData is int) {
          _dataKonsumen = responseData;
        } else {
          _dataKonsumen = 0;
        }
      });
    }
  }

  Future<void> getDataTransaksi() async {
    var response = await http
        .get(Uri.parse("$apiUrl/transaksi-data/banyak"));
    var data = json.decode(response.body);
    var responseData = data['data'];
    if (mounted) {
      setState(() {
        if (responseData is int) {
          _dataTransaksi = responseData;
        } else {
          _dataTransaksi = 0;
        }
      });
    }
  }

  Future<void> getDataStatus() async {
    var response = await http
        .get(Uri.parse("$apiUrl/transaksi-data/status"));
    var data = json.decode(response.body);
    var responseData = data['data'];
    if (mounted) {
      setState(() {
        if (responseData is int) {
          _dataStatus = responseData;
        } else {
          _dataStatus = 0;
        }
      });
    }
  }

  Future<void> getDataTotal() async {
    var response = await http
        .get(Uri.parse("$apiUrl/transaksi-data/total"));
    var data = json.decode(response.body);
    var responseData = data['data'];
    if (mounted) {
      setState(() {
        if (responseData is int) {
          _dataTotal = responseData;
        } else {
          _dataTotal = 0;
        }
      });
    }
  }

  Future<void> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    setState(() {
      username = storedUsername!;
    });
  }

  NumberFormat currencyFormatter = NumberFormat.currency(
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            cardBuild(
              title: "Member",
              numOfFiles: _dataKonsumen,
              svgSrc: "assets/icons/icons8-user-48.png",
              totalStorage: "1.9GB",
              color: primaryColor,
              percentage: 35,
            ),
            cardBuild(
              title: "Transaksi",
              numOfFiles: _dataTransaksi,
              svgSrc: "assets/icons/icons8-transaction-48.png",
              totalStorage: "2.9GB",
              color: Color(0xFFFFA113),
              percentage: 35,
            ),
            cardBuild(
              title: "Selesai",
              numOfFiles: _dataStatus,
              svgSrc: "assets/icons/icons8-invoice-48.png",
              totalStorage: "1GB",
              color: Color(0xFFA4CDFF),
              percentage: 10,
            ),
            cardBuild(
              title: "Pemasukan",
              numOfFiles: _dataTotal,
              svgSrc: "assets/icons/icons8-money-48.png",
              totalStorage: "7.3GB",
              color: Color(0xFF007EE5),
              percentage: 78,
            ),
          ],
        )
      ],
    );
  }
}

Container cardBuild({
  required String title,
  required int? numOfFiles,
  required String svgSrc,
  required String totalStorage,
  required Color color,
  required int percentage,
}) {
  String formattedNumOfFiles = '';
  int _dataTotal = 0;
  NumberFormat currencyFormatter = NumberFormat.currency(
    symbol: 'Rp',
    decimalDigits: 0,
  ); // Deklarasikan currencyFormatter di dalam fungsi cardBuild

  if (title == 'Pemasukan' && numOfFiles != null) {
    formattedNumOfFiles = NumberFormat.currency(
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(numOfFiles);
  } else {
    formattedNumOfFiles = numOfFiles.toString();
  }
  return Container(
    width: 295,
    height: 200,
    padding: EdgeInsets.all(defaultPadding),
    decoration: BoxDecoration(
      color: secondaryColor,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(defaultPadding * 0.75),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Image.asset(svgSrc),
            ),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
        Text(
          formattedNumOfFiles,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 32),
        ),
        Stack(
          children: [
            Container(
              width: 200,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) => Container(
                width: constraints.maxWidth * 0.5,
                height: 5,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    ),
  );
}
