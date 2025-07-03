/*

// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:health_app_yzta_group14/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}


*/


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Burada MyApp sınıfını import etmelisin, projenin yapısına göre yol değişir.
// Eğer main.dart ana dizindeyse şöyle import edebilirsin:
// import 'package:proje_adi/main.dart';

// Test için MyApp sınıfını tekrar yazıyorum, sen kendi projenin importunu kullan:
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Ara',
      home: Scaffold(
        appBar: AppBar(
          title: Text('GitHub Kullanıcı Ara'),
        ),
        body: Center(child: Text('Test İçin')),
      ),
    );
  }
}

void main() {
  testWidgets('Ana sayfada başlık var mı test et', (WidgetTester tester) async {
    // Widget'ı oluştur
    await tester.pumpWidget(MyApp());

    // 'GitHub Kullanıcı Ara' yazısı ekranda mı kontrol et
    expect(find.text('GitHub Kullanıcı Ara'), findsOneWidget);
  });
}
