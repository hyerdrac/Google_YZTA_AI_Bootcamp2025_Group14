import 'package:flutter/material.dart';
import 'routes.dart';
import '../core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HEASZ Health',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: appRoutes,   // buraya routes.dart içindeki map’i veriyoruz
      debugShowCheckedModeBanner: false,
    );
  }
}