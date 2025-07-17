import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero, // Üst boşluğu kaldırır
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Hoşgeldiniz!',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Hesap Bilgisi'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/account'); // Hesap ekranı
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ayarlar'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings'); // Ayarlar ekranı
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Çıkış'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/'); // Giriş ekranına dönüş
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Ana Sayfaya Hoşgeldiniz!'),
      ),
    );
  }
}