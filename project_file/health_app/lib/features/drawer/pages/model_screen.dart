import 'package:flutter/material.dart';

class ModelsScreen extends StatelessWidget {
  const ModelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahmin Modelleri')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Diyabet Modeli'),
            leading: const Icon(Icons.bloodtype),
            onTap: () {
              Navigator.pushNamed(context, '/models/diabetes');
            },
          ),
          ListTile(
            title: const Text('Akciğer Kanseri Modeli'),
            leading: const Icon(Icons.bloodtype), 
            onTap: () => Navigator.pushNamed(context, '/models/lung'),
          ),
          ListTile(
            leading: const Icon(Icons.bloodtype),
            title: const Text('Kalp Krizi Tahmin'),
            onTap: () => Navigator.pushNamed(context, '/models/heart_attack'),
          ),
          // Diğer modelleri buraya ekleyeceğiz
        ],
      ),
    );
  }
}