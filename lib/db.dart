// import 'package:mysql_utils/mysql1/mysql1.dart';
// import 'package:mysql_utils/mysql_utils.dart';

// var db = MysqlUtils(
//   settings: ConnectionSettings(
//     host: '127.0.0.1',
//     port: 3306,
//     user: 'root',
//     password: '',
//     db: 'db_laundry',
//     useCompression: false,
//     useSSL: false,
//     timeout: const Duration(seconds: 10),
//   ),
//   prefix: 'prefix_',
//   pool: true,
//   errorLog: (error) {
//     print('|$error\n├───────────────────────────');
//   },
//   sqlLog: (sql) {
//     print('|$sql\n├───────────────────────────');
//   },
//   connectInit: (db1) async {
//     print('whenComplete');
//   },
// );
