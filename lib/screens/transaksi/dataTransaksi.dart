import 'package:admin/constants.dart';
import 'package:admin/models/RecentFile.dart';
import 'package:admin/screens/transaksi/input_t.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../dashboard/header.dart';
import '../main/components/Storage_details.dart';
import '../main/components/chart.dart';
import '../main/components/judulAtas.dart';
import '../main/components/storage.dart';
import 'header_t.dart';

class data_Transaksi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(defaultPadding),
      child: Column(
        children: [
          Header_t(),
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
                      // input_data(),
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
                            Text(
                              "Recent Files",
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: DataTable(
                                  columns: [
                                    DataColumn(
                                      label: Text("Nama"),
                                    ),
                                    DataColumn(
                                      label: Text("Date"),
                                    ),
                                    DataColumn(
                                      label: Text("alamat"),
                                    )
                                  ],
                                  rows: demoRecentFiles.map((e) {
                                    return DataRow(cells: [
                                      DataCell(Text(e.title)),
                                      DataCell(Text(e.date)),
                                      DataCell(Text(e.size)),
                                    ]);
                                  }).toList()),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
              SizedBox(width: defaultPadding),
            ],
          ),
        ],
      ),
    );
  }
}
