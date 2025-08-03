import 'package:flutter/material.dart';

class LungCancerForm extends StatelessWidget {
  const LungCancerForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Akciğer Kanseri Tahmin Formu'),
        const SizedBox(height: 16),

        // Cinsiyet (Radio button)
        Row(
          children: [
            const Text('Cinsiyet: '),
            Expanded(
              child: DropdownButtonFormField<String>(
                items: const [
                  DropdownMenuItem(value: 'M', child: Text('Erkek')),
                  DropdownMenuItem(value: 'F', child: Text('Kadın')),
                ],
                onChanged: (value) {},
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Seçiniz'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Yaş (Number Input)
        TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Yaş',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),

        // Sigara (Radio Buttons)
        Row(
          children: [
            const Text('Sigara İçiyor mu? '),
            Expanded(
              child: DropdownButtonFormField<int>(
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Hayır')),
                  DropdownMenuItem(value: 2, child: Text('Evet')),
                ],
                onChanged: (value) {},
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Seçiniz'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
        // Diğer sorular için benzer inputlar ekle...

        ElevatedButton(
          onPressed: () {
            // Tahmin çağrısı burada olacak
          },
          child: const Text('Tahmin Et'),
        ),
      ],
    );
  }
}