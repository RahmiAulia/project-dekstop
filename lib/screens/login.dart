import 'dart:convert';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:admin/screens/main/main_screenAdmin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final void Function() onLogin;

  LoginScreen({required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  List<dynamic> _dataLogin = [];

  String username = '';
  String status = '';

  Future<bool> login(
      BuildContext context, String username, String password) async {
    var url = Uri.parse('http://127.0.0.1:8000/api/login');
    var response = await http.post(url, body: {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      var token = responseData['token'];
      var userStatus = responseData['status'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      await prefs.setString('status', userStatus);
      print(username);
      print(userStatus);
      return true; // Login berhasil
    } else {
      // Tangani kesalahan autentikasi
      return false; // Login gagal
    }
  }

  Future<List<dynamic>> getPaket() async {
    var response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/petugas-nama/'));
    var data = json.decode(response.body);
    setState(() {
      _dataLogin = data['data'];
    });

    // Menampilkan data username
    for (var item in _dataLogin) {
      var username = item['username'];
      print(username);
    }

    return _dataLogin;
  }

  void _login(BuildContext context) {
    String username = usernameController.text;
    String password = passwordController.text;

    login(context, username, password).then((success) {
      if (success) {
        SharedPreferences.getInstance().then((prefs) {
          String userStatus = prefs.getString('status') ?? '';

          if (userStatus == 'admin') {
            // Redirect ke tampilan admin
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreenAdmin(
                  onLogout: () {},
                ),
              ),
            );
          } else if (userStatus == 'petugas') {
            // Redirect ke tampilan petugas
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreen(
                  onLogout: () {},
                ),
              ),
            );
          } else {
            // Status tidak dikenali, tangani sesuai kebutuhan Anda
          }
        });
      } else {
        _showErrorSnackbar('Username tidak tersedia atau password salah.');
      }
    });
  }

  void _showErrorSnackbar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          errorMessage,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                "assets/images/mesin.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login Page",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 300.0,
                            child: TextField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          SizedBox(
                            width: 300.0,
                            child: TextField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock),
                              ),
                              obscureText: true,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () => _login(context),
                            child: Text('Login'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 40.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20.0),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
