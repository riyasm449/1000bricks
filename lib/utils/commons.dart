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

  static void snackBar(GlobalKey<ScaffoldState> scaffoldKey, message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}
