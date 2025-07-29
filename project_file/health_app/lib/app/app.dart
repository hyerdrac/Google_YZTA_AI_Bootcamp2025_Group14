import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import '../core/theme/app_theme.dart';
import '../provider/theme_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'HEASZ Health',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode, // Burada tema belirleniyor
            initialRoute: '/',
            routes: appRoutes,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}