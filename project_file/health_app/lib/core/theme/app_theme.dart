/*

import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
  );
}

*/



import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryBlue,
    scaffoldBackgroundColor: AppColors.lightGray,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: AppColors.white,
      elevation: 2,
      titleTextStyle: const TextStyle(
        color: AppColors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: AppColors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.turquoise,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.darkGray, fontSize: 16),
      bodySmall: TextStyle(color: AppColors.mediumGray, fontSize: 14),
      titleLarge: TextStyle(
        color: AppColors.primaryBlue,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.lightBlue),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.turquoise, width: 2),
      ),
      labelStyle: const TextStyle(color: AppColors.mediumGray),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.primaryBlue,
      contentTextStyle: const TextStyle(color: AppColors.white),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: AppColors.softGreen,
      error: AppColors.error,
      background: AppColors.lightGray,
      onPrimary: AppColors.white,
      onBackground: AppColors.darkGray,
    ),
  );
}