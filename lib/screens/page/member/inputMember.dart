// ignore_for_file: unused_local_variable, empty_statements

import 'dart:convert';
import 'dart:math';
import 'package:admin/models/MyFiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../constants.dart';
import 'package:intl/intl.dart';
import '../../../databaase.dart';
import '../../../db.dart';
// import '../../../databaase.dart';
import 'package:http/http.dart' as http;

import 'add.dart';

int generateRandomNumber() {
  final random = Random();
  return random.nextInt(1000);
}

class InputMember extends StatelessWidget {
  static DatabaseHelper databaseHelper = DatabaseHelper();
  const InputMember({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController noTelpcontroller = TextEditingController();
    final TextEditingController alamatController = TextEditingController();
    // ignore: unused_element
    Future saveKonsumen() async {
      final respon = await http
          .post(Uri.parse("http://127.0.0.1:8000/api/konsumens"), body: {
        "nama_konsumen": nameController,
        "no_telp": noTelpcontroller,
        "alamat": alamatController
      });

      print(respon.body);

      return json.decode(respon.body);
    }

    ;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Member",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                horizontal: defaultPadding * 1.5,
                vertical: defaultPadding,
              )),
              onPressed: () {
                // _showInputDialog(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TambahData()));
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

  Future<void> saveData(
      String memberId, String name, int noTelp, String alamat) async {
    // Kode untuk menyimpan data ke database MySQL
    print('ID Member: $memberId');
    print('Name: $name');
    print('No Telp: $noTelp');
    print('Alamat: $alamat');

    // DatabaseHelper databaseHelper = DatabaseHelper();

    // databaseHelper.saveData(memberId, name, noTelp, alamat);

    databaseHelper.saveData(memberId, name, noTelp, alamat);

    // await db.insert(
    //   table: 'konsumen',
    //   insertData: {
    //     'id_konsumen': '$memberId',
    //     'nama_konsumen': '$name',
    //     'no_telp': '$noTelp',
    //     'alamat': '$alamat',
    //   },
    // );
  }
}
