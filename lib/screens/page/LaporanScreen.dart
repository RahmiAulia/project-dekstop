import 'dart:convert';
import 'dart:math';
import 'package:admin/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mrx_charts/mrx_charts.dart';
import '../dashboard/header.dart';
import 'package:http/http.dart' as http;

class LaporanScreen extends StatefulWidget {
  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

List<ChartBarDataItem> chartDataItems = [];

class _LaporanScreenState extends State<LaporanScreen> {
  List<dynamic> _dataTransaksi = [];
  final String url = "$apiUrl/transaksi-data/untung";

  Future<List<dynamic>> getPaket() async {
    var response = await http.get(Uri.parse(url));
    var data = json.decode(response.body);
    setState(() {
      _dataTransaksi = data['data'];
    });
    return _dataTransaksi;
  }

  @override
  void initState() {
    super.initState();
    getPaket();
    getPaket().then((_) {
      generateChartData();
    });
  }

  void generateChartData() {
    chartDataItems = _dataTransaksi.map((paket) {
      int index = _dataTransaksi.indexOf(paket) + 1;
      return ChartBarDataItem(
        color: const Color(0xFF8043F9),
        value: paket["keuntungan"].toDouble(),
        x: index.toDouble(),
      );
    }).toList();
    setState(() {}); // Perbarui tampilan setelah menghasilkan data grafik
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
                    SizedBox(
                      height: defaultPadding,
                    ),
                    Container(
                      padding: EdgeInsets.all(defaultPadding),
                      decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          )),
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
                                    label: Text("No"),
                                  ),
                                  DataColumn(
                                    label: Text("Tanggal"),
                                  ),
                                  DataColumn(
                                    label: Text("Pemasukan"),
                                  )
                                ],
                                rows: _dataTransaksi.map((paket) {
                                  int index = _dataTransaksi.indexOf(paket) + 1;
                                  return DataRow(cells: [
                                    DataCell(
                                      Text(index
                                          .toString()), // Tampilkan nomor urut
                                    ),
                                    DataCell(
                                      Text(paket["tgl_masuk"]),
                                    ),
                                    DataCell(
                                      Text(NumberFormat.currency(
                                        symbol: 'Rp',
                                        decimalDigits: 0,
                                      ).format(paket["keuntungan"])),
                                    ),
                                  ]);
                                }).toList()),
                          ),
                          // Text('ada'),
                        ],
                      ),
                    ),
                    SizedBox(width: defaultPadding),
                  ],
                ),
              ),
              SizedBox(width: defaultPadding),
            ],
          ),
          // Expanded(
          //     child: Container(
          //   color: Colors.red,
          //   width: double.infinity,
          //   height: 300,
          // ))
          // Expanded(
          //   child: Container(
          //     width: double.infinity,
          //     height: 300,
          //     decoration: BoxDecoration(
          //         color: secondaryColor,
          //         borderRadius: const BorderRadius.all(
          //           Radius.circular(10),
          //         )),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Chart(
          //           layers: [
          //             ChartAxisLayer(
          //               settings: ChartAxisSettings(
          //                 x: ChartAxisSettingsAxis(
          //                   frequency: 1.0,
          //                   max: _dataTransaksi.length.toDouble(),
          //                   min: 0.0,
          //                   textStyle: TextStyle(
          //                     color: Colors.white.withOpacity(0.6),
          //                     fontSize: 10.0,
          //                   ),
          //                 ),
          //                 y: ChartAxisSettingsAxis(
          //                   frequency: 100.0,
          //                   max: 300.0,
          //                   min: 0.0,
          //                   textStyle: TextStyle(
          //                     color: Colors.white.withOpacity(0.6),
          //                     fontSize: 10.0,
          //                   ),
          //                 ),
          //               ),
          //               labelX: (value) => value.toInt().toString(),
          //               labelY: (value) => value.toInt().toString(),
          //             ),
          //             ChartBarLayer(
          //               items: chartDataItems,
          //               settings: const ChartBarSettings(
          //                 thickness: 8.0,
          //                 radius: BorderRadius.all(Radius.circular(4.0)),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
