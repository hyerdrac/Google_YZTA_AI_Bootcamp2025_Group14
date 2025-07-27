import 'package:flutter/material.dart';

class PersonalTrackerScreen extends StatelessWidget {
  const PersonalTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kişisel Takip'),
      ),
      body: const Center(
        child: Text(
          'Buraya kişisel takip formları gelecek.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}