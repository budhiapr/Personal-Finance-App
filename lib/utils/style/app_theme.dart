import 'package:flutter/material.dart';
import 'package:personal_finance_app/utils/style/color_schemes.g.dart';
import 'package:personal_finance_app/utils/style/typography.dart';

/// Light theme for the app
final lightAppTheme = ThemeData(
  useMaterial3: true,
  colorScheme: lightColorScheme,
  textTheme: appTextTheme,
);

/// Dark theme for the app
final darkAppTheme = ThemeData(
  useMaterial3: true,
  colorScheme: darkColorScheme,
  textTheme: appTextTheme,
);
