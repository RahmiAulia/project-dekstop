import 'dart:ffi';

import 'package:admin/models/MyFiles.dart';
import 'package:admin/screens/page/transaksi/add.dart';
import 'package:admin/screens/page/transaksi/dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

import 'package:intl/intl.dart';

class inputTransaksi extends StatelessWidget {
  const inputTransaksi({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController dateController = TextEditingController();
    final TextEditingController dateOutController = TextEditingController();
    // final TextEditingController nama = TextEditingController();
    final TextEditingController no_telpController = TextEditingController();
    final TextEditingController alamatController = TextEditingController();
    void _showInputDialog(BuildContext context) {
      DateTime selectedDate = DateTime.now();
      DateTime selectedDateOut = DateTime.now().add(Duration(days: 2));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          String name = '';
          Int no_telp;
          String alamat = '';
          // DateTime selectedDate = DateTime.now();
          // DateTime? selectedDate1;

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                SizedBox(height: defaultPadding),
                TextField(
                  controller: no_telpController,
                  onChanged: (value) {
                    no_telp = value as Int;
                  },
                  decoration: InputDecoration(
                    labelText: 'No Telp',
                  ),
                ),
                SizedBox(height: defaultPadding),
                TextField(
                  controller: alamatController,
                  onChanged: (value) {
                    alamat = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Alamat',
                  ),
                ),
                SizedBox(height: defaultPadding),
                InkWell(
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                    );
                    if (pickedDate != null) {
                      selectedDate = pickedDate;
                      dateController.text =
                          DateFormat('yyyy-MM-dd').format(selectedDate);
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Date',
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: dateController,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: 'Select a date',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: defaultPadding),
                InkWell(
                  onTap: () async {
                    final DateTime? pickedDateOut = await showDatePicker(
                      context: context,
                      initialDate: selectedDateOut,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                    );
                    if (pickedDateOut != null) {
                      selectedDateOut = pickedDateOut;
                      dateOutController.text =
                          DateFormat('yyyy-MM-dd').format(selectedDateOut);
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Tanggal Keluar',
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: dateOutController,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: 'Select a date',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: defaultPadding),
                ElevatedButton(
                  onPressed: () {
                    // Lakukan sesuatu dengan data yang diinputkan, misalnya simpan ke database atau tampilkan di layar
                    print('Name: ${nameController.text}');
                    print('No Telp: ${no_telpController.text}');
                    print('Alamat: ${alamatController.text}');
                    print('Date: $selectedDate');
                    print('Date Out: $selectedDateOut');

                    Navigator.pop(context); // Tutup dialog setelah selesai
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          );
        },
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Information",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                horizontal: defaultPadding * 1.5,
                vertical: defaultPadding,
              )),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => tambahTransaksi()));
              },
              icon: Icon(Icons.add),
              label: Text("Add New"),
            ),
          ],
        ),
        SizedBox(
          height: defaultPadding,
        ),
      ],
    );
  }
}
