import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_utils/mysql_utils.dart';

class DatabaseHelper {
  MySqlConnection? _connection;

  Future<void> connectToMySQL() async {
    final settings = ConnectionSettings(
      host: 'localhost',
      port: 3306, // port MySQL default
      user: 'root',
      password: '',
      db: 'db_laundry',
    );

    _connection = await MySqlConnection.connect(settings);
  }

  Future<void> saveData(
      String memberId, String name, int noTelp, String alamat) async {
    try {
      await connectToMySQL();

      if (_connection != null) {
        await _connection!.query(
          'INSERT INTO konsumen (id_konsumen, nama_konsumen, no_telp, alamat) VALUES (?, ?, ?, ?)',
          [memberId, name, noTelp, alamat],
        );

        print('Data has been saved to the database.');
      } else {
        print('Failed to connect to the database.');
      }

      await closeConnection();
    } catch (e) {
      print('An error occurred while saving data to the database: $e');
    }
  }

  Future<void> closeConnection() async {
    await _connection?.close();
  }
}
