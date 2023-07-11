import 'package:admin/screens/main/components/storage.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'chart.dart';

class Storrage_details extends StatelessWidget {
  const Storrage_details({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pemasukan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: defaultPadding,
          ),
          Chart(),
          Storage(
            svgSrc: "assets/icons/Documents.svg",
            title: "Cuci Gosok",
            banyak: 700,
            uang: "Rp.1.500.000",
          ),
          Storage(
            svgSrc: "assets/icons/Documents.svg",
            title: "Cuci",
            banyak: 500,
            uang: "Rp.1.200.000",
          ),
          Storage(
            svgSrc: "assets/icons/Documents.svg",
            title: "Gosok",
            banyak: 200,
            uang: "Rp.700.000",
          ),
          Storage(
            svgSrc: "assets/icons/Documents.svg",
            title: "Express",
            banyak: 110,
            uang: "Rp.500.000",
          )
        ],
      ),
    );
  }
}
