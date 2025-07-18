import 'package:flutter/material.dart';
import '../widgets/diabetes_form.dart';

class DiabetesModelScreen extends StatelessWidget {
  const DiabetesModelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diyabet Tahmini')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: DiabetesForm(),
      ),
    );
  }
}