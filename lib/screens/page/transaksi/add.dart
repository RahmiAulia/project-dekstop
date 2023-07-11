import 'dart:convert';
import 'dart:math';
import 'package:admin/constants.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:admin/screens/page/transaksi/TransaksiScreen.dart';
import 'package:admin/screens/page/transaksi/dialog.dart';
import 'package:admin/screens/page/transaksi/dialogMember.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart';

import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, double> hargaPaket = {
  'gosok': 5000,
  'cuci': 6000,
  'cuci-gosok': 7000,
};

class tambahTransaksi extends StatefulWidget {
  @override
  State<tambahTransaksi> createState() => _tambahTransaksiState();
}

class _tambahTransaksiState extends State<tambahTransaksi> {
  final _formKey = GlobalKey<FormState>();

  String idTransaksi = '';
  final TextEditingController idKonController = TextEditingController();
  final TextEditingController idAdmController = TextEditingController();
  final TextEditingController kodeController = TextEditingController();
  final TextEditingController tglMskController = TextEditingController();
  final TextEditingController tglKlrController = TextEditingController();
  final TextEditingController tglByrController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final TextEditingController ketController = TextEditingController();
  final TextEditingController nameBrgController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  String? selectedKodePaket;
  double berat = 0;
  double subtotal = 0;

  final TextEditingController beratController = TextEditingController();
  final TextEditingController subTotalController = TextEditingController();
  List<String> memberList = [];
  List<SearchFieldListItem<String>> memberSuggestions = [];
  String generatedId = '';

  Future<void> showAddNewDialog(BuildContext context) async {
    final newData = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogFormMember();
      },
    );

    if (newData != null) {
      setState(() {
        dummyTable.add(newData);
        calculateTotal(); // Hitung total setelah menambahkan data
      });
    }
  }

  @override
  String? _selectMember;
  String username = '';

  void initState() {
    super.initState();
    Random random = Random();
    int randomNumber = random.nextInt(999) + 1;

    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('yyyyMMdd').format(currentDate);

    // Mengatur tanggal masuk sebagai tanggal hari ini
    DateTime now = DateTime.now();
    tglMskController.text = DateFormat('yyyy-MM-dd').format(now);

    // Mengatur tanggal keluar sebagai 2 hari setelah hari ini
    DateTime tglKlr = now.add(Duration(days: 2));
    tglKlrController.text = DateFormat('yyyy-MM-dd').format(tglKlr);

    fetchMemberNames().then((memberNames) {
      setState(() {
        memberSuggestions = memberNames
            .map((name) => SearchFieldListItem<String>(name))
            .toList();
      });
    });
    double total = calculateTotal();
    totalController.text = total.toString();
    String generatedId = '$formattedDate$randomNumber';

// Set the generated id as the value of idController
    idController.text = generatedId;
    totalController.text = total.toString();
    getUsername();
  }

  void saveGeneratedId(String generatedId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('generatedId', generatedId);
  }

  Future<void> saveTransaksi() async {
    Object total = totalController ??
        0; // Pastikan totalController memiliki nilai yang valid

    final response = await http.post(
      Uri.parse("$apiUrl/transaksi"),
      body: {
        "id_transaksi": idController.text.toString(),
        "nama_admin": username,
        "nama_konsumen": _selectMember.toString(),
        "tgl_masuk": tglMskController.text,
        "tgl_keluar": tglKlrController.text,
        "total": totalController.text.toString(),
      },
    );

    final responseData = json.decode(response.body);

    // setState(() {
    //   idTransaksi = responseData['id'];
    // });

    print(response.body);

    return responseData;
  }

  Future<void> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    setState(() {
      username = storedUsername!;
    });
  }

  Future<List<String>> fetchMemberNames() async {
    final response = await http.get(Uri.parse("$apiUrl/konsumens-data"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<String> memberNames =
          List<String>.from(data['nama_konsumen'] ?? []);
      return memberNames;
    } else {
      throw Exception('Failed to fetch member names');
    }
  }

  Future<void> savePaket() async {
    try {
      double total = 0;

      // Menghitung total berdasarkan subtotal pada setiap item dalam dummyTable
      dummyTable.forEach((item) {
        if (item['subtotal'] is num) {
          total += (item['subtotal'] ?? 0).toDouble();
        }
      });

      final url =
          Uri.parse("$apiUrl/details"); // Ganti dengan URL endpoint yang sesuai
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'data': dummyTable,
          // 'total': total,
        }),
      );

      if (response.statusCode == 200) {
        print('Data berhasil disimpan');
      } else {
        print('Gagal menyimpan data');
      }
    } catch (e) {
      print('Gagal menyimpan data: $e');
    }
  }

  Future<void> sendDataToServer(List<Map<String, dynamic>> data) async {
    // Ubah URL sesuai dengan URL endpoint Anda
    final url = "$apiUrl/details";

    // Konversi data menjadi format JSON
    // final jsonData = data.map((item) => item.toString()).toList();
    final jsonData = jsonEncode(data);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonData,
      );
      // print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        // Data berhasil dikirim ke server
        print('Data sent successfully');
      } else {
        // Gagal mengirim data ke server
        print('Failed to send data');
      }
    } catch (e) {
      // Terjadi kesalahan saat koneksi atau pengiriman data
      print('Error: $e');
    }
  }

  List<Map<String, dynamic>> dummyTable = [];
  double calculateTotal() {
    double total = 0.0;
    for (var item in dummyTable) {
      total += item['subtotal'];
    }
    return total;
  }

  void showDialogForm(BuildContext context) async {
    final newData = await showDialog(
      context: context,
      builder: (BuildContext context) {
        String generatedId = idController.text;
        saveGeneratedId(generatedId);
        return DialogForm(); // Ganti dengan id_transaksi yang sesuai
      },
    );

    if (newData != null) {
      setState(() {
        dummyTable.add(newData);
      });
    }
  }

  void removeData(int index) {
    setState(() {
      dummyTable.removeAt(index);
      calculateTotal(); // Hitung total setelah menghapus data
    });
  }

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

  void saveDataTabel() {
    double? subtotal;

    if (selectedKodePaket != null &&
        hargaPaket.containsKey(selectedKodePaket)) {
      subtotal = berat * hargaPaket[selectedKodePaket]!;
    } else {
      // Tindakan jika selectedKodePaket bernilai null atau tidak ada dalam hargaPaket
      // Misalnya, menetapkan subtotal ke nilai default atau menampilkan pesan kesalahan.
    }

    if (_formKey.currentState!.validate()) {
      final newData = {
        'kode_paket': selectedKodePaket ?? '',
        'berat': berat,
        'subtotal': berat * hargaPaket[selectedKodePaket]!,
      };

      saveDetail(); // Mengirim data ke database

      setState(() {
        dummyTable.add(newData); // Tambahkan newData ke dummyTable
      });
      //dummyTable.add(newData); // Menambahkan data baru ke dalam tabel
      updateTotal(subtotal!);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Data Saved'),
            content: Text('Data has been saved successfully.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  updateTotal(subtotal!);
                  Navigator.pop(context);
                  // showDialogForm1(context); // Munculkan kembali dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      beratController.clear();
      subTotalController.clear();
      setState(() {
        berat = 0;
        subtotal = 0;
      });
    }
  }

  double HasilSubtotal() {
    double total = dummyTable.fold(0, (previousValue, item) {
      double subtotal = item['subtotal'] ?? 0.0;
      return previousValue + subtotal;
    });
    return total;
  }

  void showDialogForm1(BuildContext context, Function(double) updateTotal) {
    void updateSubtotal() {
      setState(() {
        subtotal = berat * hargaPaket[selectedKodePaket]!;

        subTotalController.text = subtotal.toStringAsFixed(2);
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: idController,
                decoration: InputDecoration(
                  labelText: 'ID',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the ID';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedKodePaket,
                onChanged: (value) {
                  setState(() {
                    selectedKodePaket = value!;
                  });
                  updateSubtotal();
                },
                items: hargaPaket.keys.map((String kodePaket) {
                  return DropdownMenuItem<String>(
                    value: kodePaket,
                    child: Text(kodePaket),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Kode Paket',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a package code';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: beratController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    berat = double.tryParse(value) ?? 0;
                    // subtotal = berat * 10;
                  });
                  updateSubtotal();
                },
                decoration: InputDecoration(
                  labelText: 'Berat',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the weight';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: subTotalController,
                decoration: InputDecoration(
                  labelText: 'Subtotal',
                ),
                onChanged: (value) {
                  setState(() {
                    // berat = double.tryParse(value) ?? 0;
                    berat = subtotal * hargaPaket[selectedKodePaket]!;
                    subTotalController.text = subtotal.toStringAsFixed(2);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the subtotal';
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
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                saveDataTabel();
                updateTotal(
                    subtotal); // Call the callback function to update the total
                Navigator.of(context).pop();
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  double total = 0;
  void updateTotal(double subtotal) {
    setState(() {
      total += subtotal / 2; // Menambahkan subtotal ke total
      totalController.text =
          total.toStringAsFixed(2); // Mengatur nilai total pada controller
    });
  }

  @override
  Widget build(BuildContext context) {
    double total = calculateTotal();
    int totals = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Input Data Transaksi"),
        flexibleSpace: Container(
          decoration: BoxDecoration(color: secondaryColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding * 2),
          child: Form(
            key: _formKey,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: idController,
                        // enabled: false, // Disable user input
                        decoration: InputDecoration(
                          labelText: 'Id',
                          hintText: 'Auto-generated ID',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child: Text(
                          "Pilih Member",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: SearchField(
                            hint: 'Search Member',
                            searchInputDecoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blueGrey.shade200, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue.withOpacity(0.8),
                                    width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            itemHeight: 50,
                            maxSuggestionsInViewPort: 6,
                            suggestionItemDecoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            onSubmit: (value) {
                              setState(() {
                                _selectMember = value;
                              });
                            },
                            suggestions: memberSuggestions),
                      ),
                      SizedBox(height: defaultPadding * 3),
                      Container(
                        height: 60,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _selectMember == null
                                ? Text(
                                    'pilih member',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  )
                                : Text(
                                    _selectMember!,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                            MaterialButton(
                              onPressed: () {},
                              minWidth: 30,
                              height: 30,
                              color: Colors.black,
                              padding: EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: defaultPadding),
                      ElevatedButton.icon(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: defaultPadding * 1.5,
                            vertical: defaultPadding,
                          ),
                        ),
                        onPressed: () {
                          showAddNewDialog(context);
                        },
                        icon: Icon(Icons.add),
                        label: Text("Add New"),
                      ),
                      SizedBox(height: defaultPadding * 3),
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
                            setState(() {
                              tglMskController.text =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Tanggal Masuk',
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: tglMskController,
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
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                          );
                          if (pickedDate != null) {
                            setState(() {
                              tglKlrController.text =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
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
                                  controller: tglKlrController,
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
                      TextFormField(
                        controller: totalController,
                        onChanged: (value) {
                          setState(() {
                            total = double.tryParse(value) ?? 0;
                            total = calculateTotal();
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Total $total',
                          hintText: ' Rp $total',
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
                                saveTransaksi().then((value) {
                                  Navigator.of(context);
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
                SizedBox(width: defaultPadding),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: defaultPadding),
                      SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                      dataTableTheme: DataTableThemeData()),
                                  child: DataTable(
                                    headingTextStyle: TextStyle(),
                                    columns: [
                                      DataColumn(
                                          label: Text(
                                        'Kode Paket',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Berat',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Subtotal',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      )),
                                    ],
                                    rows: dummyTable.map((item) {
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                              Text(item['kode_paket'] ?? '')),
                                          DataCell(
                                              Text(item['berat'].toString())),
                                          DataCell(Text(
                                              item['subtotal'].toString())),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                            ButtonBar(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    showDialogForm1(
                                        context,
                                        (subtotal) =>
                                            updateTotal(subtotal.toDouble()));
                                  },
                                  child: Text('add Data'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Tutup'),
                                ),
                              ],
                            ),
                            SizedBox(height: defaultPadding),
                            Text('Total: $total'),
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    btnOkOnPress: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Dashboard()),
                                      );
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
                              child: Text('Selesai'),
                            ),
                          ],
                        ),
                      ),
                      // Menampilkan total
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
