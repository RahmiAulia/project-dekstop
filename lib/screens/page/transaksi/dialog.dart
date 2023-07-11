import 'dart:math';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';

class DialogForm extends StatefulWidget {
  @override
  _DialogFormState createState() => _DialogFormState();
}

class _DialogFormState extends State<DialogForm> {
  String? selectedKodePaket;
  double berat = 0;
  double subtotal = 0;

  final TextEditingController idController = TextEditingController();
  final TextEditingController kodeController = TextEditingController();
  final TextEditingController beratController = TextEditingController();
  final TextEditingController subTotalController = TextEditingController();
  void initState() {
    super.initState();
//     Random random = Random();
//     int randomNumber = random.nextInt(999) + 1;

//     DateTime currentDate = DateTime.now();
//     String formattedDate = DateFormat('yyyyMMdd').format(currentDate);
//     // Mengatur tanggal masuk sebagai tanggal hari ini
//     DateTime now = DateTime.now();
//     tglController.text = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
//     tglklrController.text = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

//     String generatedId = '$formattedDate$randomNumber';

// // Set the generated id as the value of idController
//     idController.text = generatedId;

    //Mengatur tanggal keluar sebagai 2 hari setelah hari ini
  }

  // Future<void> saveDetail1() async {
  //   final response = await http.post(
  //     Uri.parse("http://127.0.0.1:8000/api/details"),
  //     body: {
  //       "id_transaksi": idController.text.toString(),
  //       "kode_paket": selectedKodePaket,
  //       "berat": beratController.toString(),
  //       "sub_total": subTotalController.text.toString(),
  //     },
  //   );

  //   final responseData = json.decode(response.body);
  //   // Do something with the response if needed
  // }

  Future saveDetail() async {
    final respon = await http.post(Uri.parse("$apiUrl/details"), body: {
      "id_transaksi": idController.text.toString(),
      "kode_paket": selectedKodePaket ?? '',
      "berat": beratController.text.toString(),
      "sub_total": subTotalController.text.toString(),
    });

    print(respon.body);

    return json.decode(respon.body);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void saveData() {
    if (_formKey.currentState!.validate()) {
      final newData = {
        'kode_paket': selectedKodePaket ?? '',
        'berat': berat,
        'subtotal': subtotal,
      };

      saveDetail(); // Mengirim data ke database

      Navigator.of(context).pop(newData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tambah Data'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: idController,
              // enabled: false, // Disable user input
              decoration: InputDecoration(
                labelText: 'Id',
                hintText: 'Auto-generated ID',
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedKodePaket,
              onChanged: (value) {
                setState(() {
                  selectedKodePaket = value!;
                });
              },
              items: ['Cuci', 'Gosok', 'Cuci-Gosok'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Kode Paket',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Silakan pilih kode paket';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: beratController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  berat = double.tryParse(value) ?? 0;
                  subtotal = berat * 10; // Harga barang di sini diasumsikan 10
                });
              },
              decoration: InputDecoration(
                labelText: 'Berat',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Silakan masukkan berat';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: subTotalController,
              decoration: InputDecoration(
                labelText: 'Subtotal',
              ),
              onChanged: (value) {
                setState(() {
                  berat = double.tryParse(value) ?? 0;
                  subtotal = berat * 10; // Harga barang di sini diasumsikan 10
                  subTotalController.text = subtotal.toStringAsFixed(
                      2); // Mengatur nilai subtotal pada controller
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Silakan masukkan subtotal';
                }
                return null;
              },
            ),
            Text(
              'Subtotal: $subtotal',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: saveData,
          child: Text('Simpan'),
        ),
      ],
    );
  }
}

// class DialogTable extends StatefulWidget {
//   @override
//   _DialogTableState createState() => _DialogTableState();
// }

// class _DialogTableState extends State<DialogTable> {
//   List<Map<String, dynamic>> dummyTable = [];
//   TextEditingController idController =
//       TextEditingController(); // Definisikan idController di sini

//   void initState() {
//     super.initState();
//     loadGeneratedId();
//   }

//   void loadGeneratedId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String generatedId = prefs.getString('generatedId') ?? '';
//     idController.text = generatedId;
//   }

//   //Definisikan dummyTable di sini

//   void showDialogForm(BuildContext context) async {
//     final newData = await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return DialogForm();
//       },
//     );

//     if (newData != null) {
//       setState(() {
//         dummyTable.add(newData);
//       });
//     }
//   }

//   Future<void> saveDataToDatabase() async {
//     try {
//       for (final data in dummyTable) {
//         final response = await http.post(
//           Uri.parse(" http://127.0.0.1:8000/api/details"),
//           headers: {'Content-Type': 'application/json'},
//           body: jsonEncode(data),
//         );

//         if (response.statusCode == 200) {
//           print('Data berhasil disimpan');
//         } else {
//           print('Gagal menyimpan data');
//         }
//       }
//     } catch (e) {
//       print('Gagal menyimpan data: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: DataTable(
//                   headingTextStyle: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                   columns: [
//                     DataColumn(label: Text('Kode Paket')),
//                     DataColumn(label: Text('Berat')),
//                     DataColumn(label: Text('Subtotal')),
//                   ],
//                   rows: dummyTable.map((item) {
//                     return DataRow(
//                       cells: [
//                         DataCell(Text(item['kode_paket'] ?? '')),
//                         DataCell(Text(item['berat'].toString())),
//                         DataCell(Text(item['subtotal'].toString())),
//                       ],
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//             ButtonBar(
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     showDialogForm(context);
//                   },
//                   child: Text('Tambah Data'),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     saveDataToDatabase(); // Simpan data ke database saat tombol "Tutup" ditekan
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('Tutup'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
