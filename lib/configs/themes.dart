import 'package:flutter/material.dart';
import 'package:mscpl_bhavesh_bellaney/configs/typography.dart';

class AppTheme {
  AppTheme._();

  static AppTheme instance = AppTheme._();

  ThemeData themeData = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    textTheme: textTheme,
  );
}
