import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Örnek sabit kullanıcı bilgisi
    final userName = 'Demo Kullanıcı';
    final email = 'demo@mail.com';

    return Scaffold(
      appBar: AppBar(title: const Text('Hesap Bilgisi')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kullanıcı Adı: $userName', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('E-posta: $email', style: const TextStyle(fontSize: 18)),
            // Buraya daha fazla hesap bilgisi eklenebilir
          ],
        ),
      ),
    );
  }
}