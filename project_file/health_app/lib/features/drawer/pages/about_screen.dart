import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  void _launchURL() async {
    const url = 'https://github.com/hyerdrac/Google_YZTA_AI_Bootcamp2025_Group14';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'URL açılamıyor: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hakkında')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'HEASZ Healthcare, yapay zekâ teknolojileriyle geliştirilen yenilikçi bir dijital sağlık platformudur.'
              'Uygulama, kullanıcıların medikal bilgilere kolayca erişmesini sağlamak ve kişisel sağlık takibini dijital ortamda yönetmesine olanak tanımak amacıyla tasarlanmıştır.'
              'Platform içerisinde yer alan etkileşimli insan modeli, kullanıcıların vücut bölgeleri üzerinden merak ettikleri tıbbi içeriklere açıklayıcı şekilde ulaşmalarını sağlar.'
              'Bununla birlikte kullanıcılar, kişisel sağlık verilerini kaydederek, sağlık geçmişlerini takip edebilir ve bireyselleştirilmiş sağlık analizlerine ulaşabilirler.'
              'HEASZ Healthcare, bireylerin sağlık farkındalığını artırmayı, bilgiye erişimi kolaylaştırmayı ve kendi sağlık durumlarını daha etkin yönetmelerine yardımcı olmayı hedefler.'
              ,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _launchURL,
              icon: const Icon(Icons.open_in_browser),
              label: const Text('Daha fazla bilgi için web sitemizi ziyaret edin'),
            ),
          ],
        ),
      ),
    );
  }
}