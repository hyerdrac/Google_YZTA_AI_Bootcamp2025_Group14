import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:health_app/provider/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Karanlık Mod'),
            value: themeProvider.isDarkMode,
            onChanged: (bool value) {
              themeProvider.toggleTheme(value);
            },
          ),
          const ListTile(
            title: Text('Uygulama Versiyonu'),
            subtitle: Text('v1.0.0'),
          ),
        ],
      ),
    );
  }
}