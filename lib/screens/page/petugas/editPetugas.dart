import 'dart:convert';

import 'package:admin/constants.dart';
import 'package:admin/screens/page/petugas/PetugasScreen.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';

class EditPetugas extends StatefulWidget {
  final Map petugas;

  EditPetugas({required this.petugas});

  @override
  State<EditPetugas> createState() => _EditPetugasState();
}

class _EditPetugasState extends State<EditPetugas> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController passController = TextEditingController();

  final TextEditingController levelController = TextEditingController();
  String? selectedLevel = '';
  bool obscurePassword = true;
  // ignore: unused_element
  Future updateKonsumen() async {
    final respon = await http.put(
        Uri.parse(
            "$apiUrl/petugas-update/${widget.petugas['id']}"),
        // headers: {
        //   "Content-Type": "application/x-www-form-urlencoded"
        // },
        body: {
          "username": nameController.text,
          "password": passController.text.toString(),
          "level": selectedLevel
        });

    print(respon.body);

    return jsonDecode(respon.body);
  }

  @override
  Widget build(BuildContext context) {
    String name = '';
    String pass = '';

    nameController.text = widget.petugas['username'] ?? '';
    passController.text = widget.petugas['password'] ?? '';

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
                  labelText: 'Username',
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
                controller: passController,
                obscureText: obscurePassword,
                onChanged: (value) {
                  pass = value;
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please insert data";
                  }
                  return null;
                },
              ),
              SizedBox(height: defaultPadding),
              DropdownSearch<String>(
                popupProps: PopupProps.menu(
                  showSelectedItems: true,
                ),
                items: ['Petugas', 'admin'],
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Level",
                    hintText: "pilih Level",
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedLevel = value!;
                  });
                },
                selectedItem: "Level",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Silakan pilih level';
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
                                builder: (context) => PetugasScreen()),
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
