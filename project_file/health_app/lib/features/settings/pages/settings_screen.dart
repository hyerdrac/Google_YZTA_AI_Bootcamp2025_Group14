import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = false; // Gelecekte state yönetimi ile kontrol edilir

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Karanlık Mod'),
            value: isDarkMode,
            onChanged: (bool value) {
              // Burada tema değişikliği yapılacak
            },
          ),
          ListTile(
            title: const Text('Uygulama Versiyonu'),
            subtitle: const Text('v1.0.0'),
          ),
        ],
      ),
    );
  }
}