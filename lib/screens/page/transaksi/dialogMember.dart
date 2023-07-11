import 'dart:convert';

import 'package:admin/screens/page/transaksi/add.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../constants.dart';

class DialogFormMember extends StatefulWidget {
  @override
  State<DialogFormMember> createState() => _DialogFormMemberState();
}

class _DialogFormMemberState extends State<DialogFormMember> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController noTelpController = TextEditingController();

  Future saveKonsumen() async {
    final respon = await http.post(Uri.parse("$apiUrl/konsumens"), body: {
      "nama_konsumen": namaController.text,
      "no_telp": noTelpController.text.toString(),
      "alamat": alamatController.text
    });

    print(respon.body);

    return json.decode(respon.body);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add New"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: namaController,
              decoration: InputDecoration(labelText: 'Nama'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama is required';
                }
                return null;
              },
            ),
            TextFormField(
              controller: alamatController,
              decoration: InputDecoration(labelText: 'Alamat'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Alamat is required';
                }
                return null;
              },
            ),
            TextFormField(
              controller: noTelpController,
              decoration: InputDecoration(labelText: 'No. Telepon'),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'No. Telepon is required';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
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
                    Navigator.of(context).pop();
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
    );
  }
}
