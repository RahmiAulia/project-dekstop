import 'dart:convert';

import 'package:admin/constants.dart';
import 'package:admin/screens/page/paket/PaketScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';

class tambahPaket extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController kodeController = TextEditingController();
  final TextEditingController namePktController = TextEditingController();
  final TextEditingController nameBrgController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  // ignore: unused_element
  Future savePaket() async {
    final respon = await http.post(Uri.parse("$apiUrl/pakets"), body: {
      "kode_paket": kodeController.text,
      "nama_paket": namePktController.text,
      "nama_barang": nameBrgController.text,
      "harga_barang": hargaController.text.toString(),
    });

    print(respon.body);

    return json.decode(respon.body);
  }

  @override
  Widget build(BuildContext context) {
    String kode_paket = '';
    String nama_paket = '';
    String nama_barang = '';
    int harga_barang;
    return Scaffold(
      appBar: AppBar(
        title: Text("Input Data Paket"),
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
                        savePaket().then((value) {
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
