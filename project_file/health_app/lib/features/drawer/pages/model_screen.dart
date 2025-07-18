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
          // Diğer modelleri buraya ekleyeceğiz
        ],
      ),
    );
  }
}