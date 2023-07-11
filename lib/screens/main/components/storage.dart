import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';

class Storage extends StatelessWidget {
  const Storage({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.uang,
    required this.banyak,
  }) : super(key: key);

  final String title, svgSrc, uang;
  final int banyak;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: defaultPadding),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
          borderRadius:
              const BorderRadius.all(Radius.circular(defaultPadding))),
      child: Row(children: [
        SizedBox(
          height: 20,
          width: 20,
          child: SvgPicture.asset(svgSrc),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "$banyak x",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white70),
              )
            ],
          ),
        )),
        Text(uang)
      ]),
    );
  }
}
