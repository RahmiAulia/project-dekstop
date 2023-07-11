import 'dart:convert';

import 'package:admin/constants.dart';
import 'package:admin/models/RecentFile.dart';
import 'package:admin/screens/page/components/input.dart';
import 'package:admin/screens/page/member/inputMember.dart';
import 'package:admin/screens/page/member/editMember.dart';
import 'package:admin/screens/page/paket/editMember.dart';
import 'package:admin/screens/page/paket/header.dart';
import 'package:admin/screens/transaksi/input_t.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../dashboard/header.dart';
import '../../main/components/Storage_details.dart';
import '../../main/components/chart.dart';
import '../../main/components/judulAtas.dart';
import '../../main/components/storage.dart';
import 'package:http/http.dart' as http;

class PaketScreen extends StatefulWidget {
  @override
  _PaketScreenState createState() => _PaketScreenState();
}

class _PaketScreenState extends State<PaketScreen> {
  bool _isDataDeleted = false;
  List<dynamic> _dataPaket = [];
  final String url = "http://127.0.0.1:8000/api/pakets-data";

  Future<List<dynamic>> getPaket() async {
    var response = await http.get(Uri.parse(url));
    var data = json.decode(response.body);
    setState(() {
      _dataPaket = data['data'];
    });
    return _dataPaket;
  }

  Future<void> deleteKonsumen(int id) async {
    final response = await http
        .delete(Uri.parse("http://127.0.0.1:8000/api/pakets-delete/$id"));
    if (response.statusCode == 200) {
      print("Data deleted successfully");
    } else {
      print("Failed to delete data");
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
                    inputPaket(),
                    SizedBox(
                      height: defaultPadding,
                    ),
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
                              Text("${_dataPaket.length} data"),
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
                                  label: Text("Kode Paket"),
                                ),
                                DataColumn(
                                  label: Text("Nama Paket"),
                                ),
                                DataColumn(
                                  label: Text("Nama barang"),
                                ),
                                DataColumn(
                                  label: Text("Harga barang"),
                                ),
                                DataColumn(
                                  label: Text("Action"),
                                ),
                              ],
                              rows: _dataPaket.map((paket) {
                                int index = _dataPaket.indexOf(paket) + 1;
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(index
                                          .toString()), // Tampilkan nomor urut
                                    ),
                                    DataCell(
                                      Text(paket["kode_paket"]),
                                    ),
                                    DataCell(
                                      Text(paket["nama_paket"]),
                                    ),
                                    DataCell(
                                      Text(paket["nama_barang"]),
                                    ),
                                    DataCell(
                                      Text(paket["harga_barang"]),
                                    ),
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          editPaket(
                                                            paket: paket,
                                                          )));
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              if (!_isDataDeleted) {
                                                showCupertinoDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return CupertinoAlertDialog(
                                                      title: Text(
                                                          'Konfirmasi Hapus'),
                                                      content: Text(
                                                          'Anda yakin ingin menghapus data?'),
                                                      actions: [
                                                        CupertinoDialogAction(
                                                          child: Text(
                                                            'Nanti saja',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                        CupertinoDialogAction(
                                                          child: Text(
                                                            'Iya',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green),
                                                          ),
                                                          onPressed: () async {
                                                            await deleteKonsumen(
                                                                paket['id']);
                                                            setState(() {
                                                              _isDataDeleted =
                                                                  true;
                                                              getPaket();
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
                                                                      'Success'),
                                                                  content: Text(
                                                                      'Data berhasil dihapus!'),
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
