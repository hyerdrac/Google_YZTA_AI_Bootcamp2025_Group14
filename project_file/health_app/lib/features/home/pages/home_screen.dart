import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health_app/core/constants/prompt.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? tappedRegion;
  String? llmResponse;

  void _handleRegionTap(String regionName) {
    setState(() {
      tappedRegion = regionName;
      llmResponse = prompts[regionName] ?? "";
    });
  }

  Widget _buildRegion(String regionName, Alignment alignment,
      double widthFactor, double heightFactor) {
    return Align(
      alignment: alignment,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        child: GestureDetector(
          onTap: () => _handleRegionTap(regionName),
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Hoşgeldiniz!',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Ana Sayfa'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Modeller'),
              onTap: () => Navigator.pushNamed(context, '/models'),
            ),
            ListTile(
              leading: const Icon(Icons.track_changes),
              title: const Text('Kişisel Takip'),
              onTap: () => Navigator.pushNamed(context, '/personal-tracker'),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Hesap Bilgisi'),
              onTap: () => Navigator.pushNamed(context, '/account'),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ayarlar'),
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Hakkında'),
              onTap: () => Navigator.pushNamed(context, '/about'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Çıkış'),
              onTap: () => Navigator.pushReplacementNamed(context, '/'),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child: Stack(
                children: [
                  SvgPicture.asset(
                    'assets/human_model_project.svg',
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  _buildRegion('head', const Alignment(0, -0.85), 0.2, 0.15),
                  _buildRegion('left_arm', const Alignment(-0.7, -0.4), 0.2, 0.3),
                  _buildRegion('right_arm', const Alignment(0.7, -0.4), 0.2, 0.3),
                  _buildRegion('upper_body', const Alignment(0, -0.3), 0.3, 0.2),
                  _buildRegion('lower_body', const Alignment(0, 0.1), 0.28, 0.2),
                  _buildRegion('left_leg', const Alignment(-0.25, 0.6), 0.15, 0.3),
                  _buildRegion('right_leg', const Alignment(0.25, 0.6), 0.15, 0.3),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              color: theme.colorScheme.surface,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    tappedRegion != null
                        ? 'Seçilen Bölge: $tappedRegion'
                        : 'Bir bölgeye dokunun',
                    style: textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  if (llmResponse != null)
                    SelectableText(
                      llmResponse!,
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}