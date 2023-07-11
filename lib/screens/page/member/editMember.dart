import 'dart:convert';

import 'package:admin/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';

import 'MemberScreen.dart';

class editMember extends StatelessWidget {
  final Map member;

  editMember({required this.member});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController noTelpcontroller = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  // ignore: unused_element
  Future updateKonsumen() async {
    final respon =
        await http.put(Uri.parse("$apiUrl/konsumens-update/${member['id']}"),
            // headers: {
            //   "Content-Type": "application/x-www-form-urlencoded"
            // },
            body: {
          "nama_konsumen": nameController.text,
          "no_telp": noTelpcontroller.text.toString(),
          "alamat": alamatController.text
        });

    print(respon.body);

    return jsonDecode(respon.body);
  }

  @override
  Widget build(BuildContext context) {
    String name = '';
    int no_telp;
    String alamat = '';
    nameController.text = member['nama_konsumen'] ?? '';
    noTelpcontroller.text = member['no_telp'] ?? '';
    alamatController.text = member['alamat'] ?? '';
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
                        updateKonsumen().then((value) {
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
