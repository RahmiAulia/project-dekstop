import 'dart:convert';

import 'package:admin/constants.dart';
import 'package:admin/screens/page/paket/PaketScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';

class editPaket extends StatelessWidget {
  final Map paket;
  final _formKey = GlobalKey<FormState>();
  editPaket({required this.paket});
  final TextEditingController kodeController = TextEditingController();
  final TextEditingController namePktController = TextEditingController();
  final TextEditingController nameBrgController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  // ignore: unused_element
  Future updateKonsumen() async {
    final respon =
        await http.put(Uri.parse("$apiUrl/pakets-update/${paket['id']}"),
            // headers: {
            //   "Content-Type": "application/x-www-form-urlencoded"
            // },
            body: {
          "kode_paket": kodeController.text,
          "nama_paket": namePktController.text,
          "nama_barang": nameBrgController.text,
          "harga_barang": hargaController.text.toString(),
        });

    print(respon.body);

    return jsonDecode(respon.body);
  }

  @override
  Widget build(BuildContext context) {
    String kode_paket = '';
    String nama_paket = '';
    String nama_barang = '';
    int harga_barang;
    kodeController.text = paket['kode_paket'] ?? '';
    namePktController.text = paket['nama_paket'] ?? '';
    nameBrgController.text = paket['nama_barang'] ?? '';
    hargaController.text = paket['harga_barang'] ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Data Member"),
        // leading: Icon(Icons.dataset_rounded),
        flexibleSpace: Container(
          decoration: BoxDecoration(color: secondaryColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding * 2),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: kodeController,
                onChanged: (value) {
                  kode_paket = value;
                },
                decoration: InputDecoration(
                  labelText: 'kode paket',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please insert data";
                  }
                  return null;
                },
              ),
              SizedBox(height: defaultPadding),
              TextFormField(
                controller: namePktController,
                onChanged: (value) {
                  kode_paket = value;
                },
                decoration: InputDecoration(
                  labelText: 'nama paket',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please insert data";
                  }
                  return null;
                },
              ),
              SizedBox(height: defaultPadding),
              TextFormField(
                controller: nameBrgController,
                onChanged: (value) {
                  kode_paket = value;
                },
                decoration: InputDecoration(
                  labelText: 'nama barang',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please insert data";
                  }
                  return null;
                },
              ),
              SizedBox(height: defaultPadding),
              TextFormField(
                controller: hargaController,
                onChanged: (value) {
                  harga_barang = int.tryParse(value) ?? 0;
                },
                decoration: InputDecoration(
                  labelText: 'harga barang',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please insert data";
                  }
                  return null;
                },
              ),
              SizedBox(height: defaultPadding),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                    // Operasi berhasil
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.SUCCES,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Success',
                      desc: 'Data saved successfully!',
                      width: MediaQuery.of(context).size.width * 0.7,
                      btnOkOnPress: () {
                        updateKonsumen().then((value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaketScreen()),
                          );
                        });
                      },
                    )..show();
                  } else {
                    // Operasi gagal
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.ERROR,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Error',
                      desc: 'Failed to save data!',
                      btnOkOnPress: () {},
                    )..show();
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
