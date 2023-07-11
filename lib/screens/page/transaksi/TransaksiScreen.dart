import 'dart:convert';
import 'package:admin/constants.dart';
import 'package:admin/screens/page/paket/editMember.dart';
import 'package:admin/screens/page/transaksi/inputTransaksi.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../dashboard/header.dart';
import 'package:http/http.dart' as http;

class TransaksiScreen extends StatefulWidget {
  @override
  _TransaksiScreenState createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  bool _isDataDeleted = false;
  List<dynamic> _dataTransaksi = [];
  final String url = "$apiUrl/transaksi-data/notNull";

  Future<List<dynamic>> getPaket() async {
    var response = await http.get(Uri.parse(url));
    var data = json.decode(response.body);
    setState(() {
      _dataTransaksi = data['data'];
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
                    inputTransaksi(),
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
                              Text("${_dataTransaksi.length} data"),
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
                                DataColumn(
                                  label: Text("Keterangan"),
                                ),
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
                                      Text(NumberFormat.currency(
                                        symbol: 'Rp',
                                        decimalDigits: 0,
                                      ).format(
                                          double.parse(paket["total"] ?? '0'))),
                                    ),
                                    DataCell(
                                      Text(paket["status"]),
                                    ),
                                    DataCell(
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: paket["tgl_ambil"] != null
                                              ? Colors.green
                                              : null,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          paket["tgl_ambil"] != null
                                              ? 'Sudah diambil'
                                              : '',
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
