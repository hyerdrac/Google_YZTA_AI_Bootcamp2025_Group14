import 'package:flutter/material.dart';
import '../features/auth/pages/login_screen.dart';
import '../features/home/pages/home_screen.dart';
import '../features/settings/pages/settings_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const LoginScreen(),
  '/home': (context) => const HomeScreen(),
  '/settings': (context) => const SettingsScreen(),
};