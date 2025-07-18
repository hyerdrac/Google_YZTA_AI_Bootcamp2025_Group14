import 'package:flutter/material.dart';

class DiabetesForm extends StatelessWidget {
  const DiabetesForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Diyabet için tahmin formu'),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Glukoz Seviyesi',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Buraya tahmin çağrısı gelecek
          },
          child: const Text('Tahmin Et'),
        ),
      ],
    );
  }
}