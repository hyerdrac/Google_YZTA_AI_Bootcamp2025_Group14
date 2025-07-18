import 'package:flutter/material.dart';
import '../features/auth/pages/login_screen.dart';
import '../features/home/pages/home_screen.dart';
import '../features/settings/pages/settings_screen.dart';
import 'package:health_app/features/drawer/pages/model_screen.dart';
import 'package:health_app/features/pred_models/diabetes/pages/diabetes_model_screen.dart';


final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const LoginScreen(),
  '/home': (context) => const HomeScreen(),
  '/settings': (context) => const SettingsScreen(),
  // '/account': (context) => const AccountScreen(),
  // '/about': (context) => const AboutScreen(),

  // Tahmin Modelleri
  '/models': (context) => const ModelsScreen(),
  '/models/diabetes': (context) => const DiabetesModelScreen(),


};