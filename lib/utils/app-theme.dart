import 'package:flutter/material.dart';

import 'commons.dart';

final appTheme = ThemeData(
  primaryColor: Commons.bgColor,
  unselectedWidgetColor: Colors.white,
  accentIconTheme: IconThemeData(color: Commons.bgColor),
  textTheme: const TextTheme(bodyText1: TextStyle(fontFamily: 'Nunito')),
  iconTheme: IconThemeData(color: Commons.bgColor),
  fontFamily: 'Nunito',
  hintColor: Commons.hintColor,
);
