import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Commons {
  static const hintColor = Color(0xFF4D0F29);
  static Color bgColor = Commons.colorFromHex('#72000c');
  static Color bgLightColor = Commons.colorFromHex('#a7505f');

  static Color greyAccent1 = Commons.colorFromHex('#f7f7f7');
  static Color greyAccent2 = Commons.colorFromHex('#cccccc');
  static Color greyAccent3 = Commons.colorFromHex('#999999');
  static Color greyAccent4 = Commons.colorFromHex('#8e8e93');
  static Color greyAccent5 = Commons.colorFromHex('#333333');

  static Color colorFromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  // static Widget topBar(BuildContext context) {
  //   return Stack(
  //     children: [
  //       Container(
  //         width: MediaQuery.of(context).size.width,
  //         height: 120,
  //       ),
  //       Positioned(
  //         top: -100,
  //         right: -100,
  //         child: Container(
  //           width: 200,
  //           height: 200,
  //           decoration: BoxDecoration(color: Commons.bgColor, borderRadius: BorderRadius.circular(100)),
  //         ),
  //       ),
  //       Positioned(top: -50, left: -75, child: innerCircle()),
  //       Positioned(
  //         top: -100,
  //         left: 0,
  //         child: Container(
  //           width: 200,
  //           height: 200,
  //           decoration: BoxDecoration(color: Commons.bgLightColor, borderRadius: BorderRadius.circular(100)),
  //         ),
  //       ),
  //       Positioned(top: 65, left: 30, child: backButton(context))
  //     ],
  //   );
  // }

  // static Widget backButton(BuildContext context) {
  //   return InkWell(
  //     onTap: () {
  //       Navigator.of(context).pop();
  //     },
  //     child: Container(
  //       width: 40,
  //       height: 40,
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(10),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.grey.withOpacity(.5),
  //             blurRadius: 2.0, // soften the shadow
  //             spreadRadius: 1.5, //extend the shadow
  //             offset: Offset(
  //               1.0, // Move to right 10  horizontally
  //               1.0, // Move to bottom 10 Vertically
  //             ),
  //           ),
  //         ],
  //       ),
  //       child: Icon(Icons.navigate_before_outlined),
  //     ),
  //   );
  // }
}
