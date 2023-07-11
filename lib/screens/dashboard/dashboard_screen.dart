import 'dart:convert';

import 'package:admin/constants.dart';
import 'package:admin/models/RecentFile.dart';
import 'package:admin/screens/page/paket/editMember.dart';
import 'package:admin/screens/page/transaksi/TransaksiScreen.dart';
import 'package:admin/screens/page/transaksi/inputTransaksi.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../main/components/Storage_details.dart';
import '../main/components/chart.dart';
import '../main/components/judulAtas.dart';
import '../main/components/storage.dart';
import 'header.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isDataDeleted = false;
  bool isAmbil = false;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  List<dynamic> _dataTransaksi = [];
  final String url = "$apiUrl/transaksi-data";

  Future<List<dynamic>> getPaket() async {
    var response = await http.get(Uri.parse(url));
    var data = json.decode(response.body);
    setState(() {
      _dataTransaksi = data['data'];
      _dataTransaksi.sort((a, b) {
        if (a['status'] == 'proses' && a['tgl_ambil'] == null) {
          return -1;
        } else if (b['status'] == 'proses' && b['tgl_ambil'] == null) {
          return 1;
        } else if (a['status'] == 'selesai' && a['tgl_ambil'] == null) {
          return -1;
        } else if (b['status'] == 'selesai' && b['tgl_ambil'] == null) {
          return 1;
        } else if (a['status'] == 'selesai' &&
            b['status'] == 'selesai' &&
            a['tgl_ambil'] != null &&
            b['tgl_ambil'] == null) {
          return -1;
        } else if (a['status'] == 'selesai' &&
            b['status'] == 'selesai' &&
            a['tgl_ambil'] == null &&
            b['tgl_ambil'] != null) {
          return 1;
        } else {
          return 0;
        }
      });
    });
    return _dataTransaksi;
  }

  Future<void> deleteKonsumen(int id) async {
    final response = await http.delete(Uri.parse("$apiUrl/pakets-delete/$id"));
    if (response.statusCode == 200) {
      print("Data deleted successfully");
    } else {
      print("Failed to delete data");
    }
  }

  Future<void> updateStatus(int id) async {
    final response = await http.put(
      Uri.parse("$apiUrl/transaksi-data/update/$id"),
      body: {'status': 'selesai'},
    );

    if (response.statusCode == 200) {
      print("Status updated successfully");
      getPaket();
    } else {
      print("Failed to update status");
    }
  }

  Future<void> updateAmbil(int id) async {
    final DateFormat currentDate = DateFormat('yyyy-MM-dd');
    final response = await http.put(
      Uri.parse("$apiUrl/transaksi-data/ambil/$id"),
      body: {'tgl_ambil': currentDate.format(DateTime.now())},
    );

    if (response.statusCode == 200) {
      print("Status updated successfully");

      setState(() {
        isAmbil = true;
      });
      getPaket();
    } else {
      print("Failed to update status");
    }
  }

  Color _getStatusColor(String status) {
    if (status == "selesai") {
      return Colors.green;
    } else if (status == "proses") {
      return Colors
          .blue; // Ganti dengan warna yang diinginkan untuk status "Progress"
    } else {
      return Colors.transparent;
    }
  }

  @override
  void initState() {
    super.initState();
    getPaket();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: _navigatorKey,
      padding: EdgeInsets.all(defaultPadding),
      child: Column(
        children: [
          Header(),
          SizedBox(
            height: defaultPadding,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    judulAtas(),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    inputTransaksi(),
                    Container(
                      padding: EdgeInsets.all(defaultPadding),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Recent Files",
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              ElevatedButton.icon(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: defaultPadding * 1.5,
                                    vertical: defaultPadding,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Dashboard()),
                                  );
                                },
                                icon: Icon(Icons.refresh),
                                label: Text("Refresh"),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: DataTable(
                              columns: [
                                DataColumn(
                                  label: Text("No."),
                                ),
                                DataColumn(
                                  label: Text("Nama Konsumen"),
                                ),
                                DataColumn(
                                  label: Text("Tanggal Masuk"),
                                ),
                                DataColumn(
                                  label: Text("Tanggal keluar"),
                                ),
                                DataColumn(
                                  label: Text("Total"),
                                ),
                                DataColumn(
                                  label: Text("Status"),
                                ),
                                //
                                DataColumn(
                                  label: Text("Action"),
                                ),
                              ],
                              rows: _dataTransaksi.map((paket) {
                                int index = _dataTransaksi.indexOf(paket) + 1;
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(index
                                          .toString()), // Tampilkan nomor urut
                                    ),
                                    DataCell(
                                      Text(paket["nama_konsumen"]),
                                    ),
                                    DataCell(
                                      Text(paket["tgl_masuk"]),
                                    ),
                                    DataCell(
                                      Text(paket["tgl_keluar"]),
                                    ),
                                    DataCell(
                                      Text(paket["total"]),
                                    ),
                                    DataCell(
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color:
                                              _getStatusColor(paket["status"]),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          paket["status"],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.check),
                                            onPressed: () {
                                              if (!_isDataDeleted) {
                                                showCupertinoDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return CupertinoAlertDialog(
                                                      title: Text(
                                                          'Konfirmasi Selesai'),
                                                      content: Text(
                                                          'Anda yakin ingin mengganti status menjadi "Selesai"?'),
                                                      actions: [
                                                        CupertinoDialogAction(
                                                          child: Text('Batal'),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                        CupertinoDialogAction(
                                                          child:
                                                              Text('Selesai'),
                                                          onPressed: () async {
                                                            await updateStatus(
                                                                paket['id']);
                                                            setState(() {
                                                              _isDataDeleted =
                                                                  true;
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return CupertinoAlertDialog(
                                                                  title: Text(
                                                                      'Berhasil'),
                                                                  content: Text(
                                                                      'Status berhasil diubah menjadi "Selesai"!'),
                                                                  actions: [
                                                                    CupertinoDialogAction(
                                                                      child: Text(
                                                                          'OK'),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.info),
                                            onPressed: () async {
                                              if (!_isDataDeleted) {
                                                await updateAmbil(paket['id']);
                                                setState(() {
                                                  _isDataDeleted = true;
                                                });
                                                showCupertinoDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return CupertinoAlertDialog(
                                                      title: Text('Informasi'),
                                                      content: Text(
                                                          'Paket ini sudah diambil.'),
                                                      actions: [
                                                        CupertinoDialogAction(
                                                          child: Text('OK'),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: defaultPadding),
            ],
          ),
        ],
      ),
    );
  }
}
