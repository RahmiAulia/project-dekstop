// import 'package:admin/models/MyFiles.dart';
// import 'package:admin/screens/main/components/inputData.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// import '../../../constants.dart';

// class input_data extends StatelessWidget {
//   const input_data({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Information",
//               style: Theme.of(context).textTheme.subtitle1,
//             ),
//             ElevatedButton.icon(
//               style: TextButton.styleFrom(
//                   padding: EdgeInsets.symmetric(
//                 horizontal: defaultPadding * 1.5,
//                 vertical: defaultPadding,
//               )),
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => InputData()));
//               },
//               icon: Icon(Icons.add),
//               label: Text("Add New"),
//             ),
//           ],
//         ),
//         SizedBox(
//           height: defaultPadding,
//         ),
//       ],
//     );
//   }
// }
