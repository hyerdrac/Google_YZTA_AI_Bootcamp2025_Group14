import 'package:flutter/material.dart';
import 'package:health_app/app/app.dart';

import 'package:provider/provider.dart';
import 'package:health_app/provider/theme_provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}