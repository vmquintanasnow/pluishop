library multicuba_components;

import 'package:flutter/material.dart';

class DecoratorTheme {
  ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: AppColors.primaryColor,
      accentColor: AppColors.accentColor,
      buttonColor: AppColors.secondaryColor,
      disabledColor: AppColors.disabledColor,
      tabBarTheme: TabBarTheme(
          labelColor: AppColors.accentColor,
          labelPadding: const EdgeInsets.symmetric(horizontal: 4),                 
          indicator: BoxDecoration(
              color: Colors.white,              
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0)),),
          unselectedLabelColor: AppColors.disabledColor.withOpacity(0.5)),
      textTheme: TextTheme(button: TextStyle(color: Colors.white)),
      appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          color: AppColors.primaryColor,
          actionsIconTheme: IconThemeData(color: AppColors.secondaryColor)),
    );
  }
  ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: AppColors.primaryColor,
      accentColor: AppColors.accentColor,
      buttonColor: AppColors.secondaryColor,
      disabledColor: AppColors.disabledColor,
     tabBarTheme: TabBarTheme(
          labelColor: AppColors.accentColor,
          labelPadding: const EdgeInsets.symmetric(horizontal: 4),                 
          indicator: BoxDecoration(
              color: Colors.white,              
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0)),),
          unselectedLabelColor: AppColors.disabledColor.withOpacity(0.5)),
      textTheme: TextTheme(button: TextStyle(color: Colors.white)),
      appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          color: AppColors.primaryColor,
          actionsIconTheme: IconThemeData(color: AppColors.secondaryColor)),
    );
  }
}


class AppColors {
  static Color primaryColor = Color(0xff353e4a);
  static Color secondaryColor = Color(0xffff5500);
  static Color accentColor = Color(0xffef6c00);
  static Color secondaryTextColor = Color(0xff074f84);
  static Color accentTextColor = Color(0xff0699d2);
  static Color disabledColor = Color(0xffbfbfbf);
}