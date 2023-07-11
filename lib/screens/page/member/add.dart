import 'dart:convert';

import 'package:admin/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';

import 'MemberScreen.dart';

class TambahData extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController noTelpcontroller = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  // ignore: unused_element
  Future saveKonsumen() async {
    final respon = await http.post(Uri.parse("$apiUrl/konsumens"), body: {
      "nama_konsumen": nameController.text,
      "no_telp": noTelpcontroller.text.toString(),
      "alamat": alamatController.text
    });

    print(respon.body);

    return json.decode(respon.body);
  }

  @override
  Widget build(BuildContext context) {
    String name = '';
    int no_telp;
    String alamat = '';
    return Scaffold(
      appBar: AppBar(
        title: Text("Input Data Member"),
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
                controller: nameController,
                onChanged: (value) {
                  name = value;
                },
                decoration: InputDecoration(
                  labelText: 'Name',
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
                controller: noTelpcontroller,
                onChanged: (value) {
                  no_telp = int.tryParse(value) ?? 0;
                },
                decoration: InputDecoration(
                  labelText: 'No Telp',
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
                controller: alamatController,
                onChanged: (value) {
                  alamat = value;
                },
                decoration: InputDecoration(
                  labelText: 'Alamat',
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
                        saveKonsumen().then((value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MemberScreen()),
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
