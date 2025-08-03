import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HeartAttackScreen extends StatefulWidget {
  const HeartAttackScreen({super.key});

  @override
  State<HeartAttackScreen> createState() => _HeartAttackScreenState();
}

class _HeartAttackScreenState extends State<HeartAttackScreen> {
  final _formKey = GlobalKey<FormState>();

  // Modeldeki değişkenler
  String age = '';
  String sex = 'M'; // M/F
  String cholesterol = '';
  String bloodPressure = '';
  String heartRate = '';
  int diabetes = 0; // 1=Yes, 0=No
  int familyHistory = 0; // 1=Yes, 0=No
  int smoking = 0; // 1=Smoker, 0=Non-smoker
  int obesity = 0; // 1=Obese, 0=Not obese
  String alcoholConsumption = 'None'; // None/Light/Moderate/Heavy
  String exerciseHours = '';
  String diet = 'Healthy'; // Healthy/Average/Unhealthy
  int previousHeartProblems = 0; // 1=Yes, 0=No
  int medicationUse = 0; // 1=Yes, 0=No
  int stressLevel = 1; // 1-10 arası
  String sedentaryHours = '';
  String income = '';

  String? predictionResult;
  bool isLoading = false;

  // Buraya kendi Hugging Face Space API adresini yaz
  final String apiUrl = '';
  final String pollingBase = '/';
  final String? hfApiToken = null; // private ise token ekle

  Future<void> predict() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      predictionResult = null;
    });

    try {
      // Model inputu "data" olarak API'ye gönderiliyor.
      final inputData = {
        "data": [
          int.parse(age),
          sex,
          int.parse(cholesterol),
          bloodPressure,
          int.parse(heartRate),
          diabetes,
          familyHistory,
          smoking,
          obesity,
          alcoholConsumption,
          double.parse(exerciseHours),
          diet,
          previousHeartProblems,
          medicationUse,
          stressLevel,
          double.parse(sedentaryHours),
          income,
        ]
      };

      Map<String, String> headers = {'Content-Type': 'application/json'};
      if (hfApiToken != null && hfApiToken!.isNotEmpty) {
        headers['Authorization'] = 'Bearer $hfApiToken';
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(inputData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        final String eventId = result['event_id'];
        await pollResult(eventId, headers);
      } else {
        setState(() {
          predictionResult = 'Sunucu hatası: ${response.statusCode}\nYanıt: ${response.body}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        predictionResult = 'Bağlantı hatası veya format hatası: $e';
        isLoading = false;
      });
    }
  }

  Future<void> pollResult(String eventId, Map<String, String> headers) async {
    const int maxTries = 60;
    const delay = Duration(seconds: 1);

    for (int i = 0; i < maxTries; i++) {
      await Future.delayed(delay);

      try {
        final response = await http.get(
          Uri.parse('$pollingBase$eventId'),
          headers: headers,
        );

        if (response.statusCode == 200) {
          final lines = response.body.split('\n');
          String? eventType;
          String? data;

          for (final line in lines) {
            if (line.startsWith('event:')) {
              eventType = line.replaceFirst('event:', '').trim();
            } else if (line.startsWith('data:')) {
              data = line.replaceFirst('data:', '').trim();
            }
          }

          if (eventType == 'complete') {
            final result = jsonDecode(data!);
            setState(() {
              predictionResult = 'Tahmin sonucu: ${result[0]}';
              isLoading = false;
            });
            return;
          }
        } else {
          setState(() {
            predictionResult = 'Polling hatası: ${response.statusCode}';
            isLoading = false;
          });
          return;
        }
      } catch (e) {
        setState(() {
          predictionResult = 'Polling hatası: $e';
          isLoading = false;
        });
        return;
      }
    }

    setState(() {
      predictionResult = 'Tahmin zaman aşımına uğradı.';
      isLoading = false;
    });
  }

  // Dropdown ya da TextField widget yardımcıları

  Widget buildDropdown<T>(String label, T value, List<T> options, ValueChanged<T> onChanged) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      items: options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt.toString()))).toList(),
      onChanged: (val) => onChanged(val!),
    );
  }

  Widget buildTextField(String label, String initialValue, ValueChanged<String> onChanged, {TextInputType keyboardType = TextInputType.text, String? Function(String?)? validator}) {
    return TextFormField(
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      keyboardType: keyboardType,
      initialValue: initialValue,
      validator: validator,
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kalp Krizi Tahmin')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField('Yaş', age, (val) => age = val, keyboardType: TextInputType.number, validator: (val) => (val == null || val.isEmpty) ? 'Yaş giriniz' : null),
              buildDropdown<String>('Cinsiyet (M/F)', sex, ['M', 'F'], (val) => setState(() => sex = val)),
              buildTextField('Kolesterol', cholesterol, (val) => cholesterol = val, keyboardType: TextInputType.number, validator: (val) => (val == null || val.isEmpty) ? 'Kolesterol giriniz' : null),
              buildTextField('Kan Basıncı (Sistolik/Diastolik)', bloodPressure, (val) => bloodPressure = val, validator: (val) => (val == null || val.isEmpty) ? 'Kan basıncı giriniz' : null),
              buildTextField('Kalp Hızı', heartRate, (val) => heartRate = val, keyboardType: TextInputType.number, validator: (val) => (val == null || val.isEmpty) ? 'Kalp hızı giriniz' : null),
              buildDropdown<int>('Diyabet (1=Evet, 0=Hayır)', diabetes, [0,1], (val) => setState(() => diabetes = val)),
              buildDropdown<int>('Ailede Kalp Hastalığı (1=Evet, 0=Hayır)', familyHistory, [0,1], (val) => setState(() => familyHistory = val)),
              buildDropdown<int>('Sigara (1=Evet, 0=Hayır)', smoking, [0,1], (val) => setState(() => smoking = val)),
              buildDropdown<int>('Obezite (1=Evet, 0=Hayır)', obesity, [0,1], (val) => setState(() => obesity = val)),
              buildDropdown<String>('Alkol Tüketimi', alcoholConsumption, ['None', 'Light', 'Moderate', 'Heavy'], (val) => setState(() => alcoholConsumption = val)),
              buildTextField('Haftalık Egzersiz Saati', exerciseHours, (val) => exerciseHours = val, keyboardType: TextInputType.number, validator: (val) => (val == null || val.isEmpty) ? 'Egzersiz saati giriniz' : null),
              buildDropdown<String>('Diyet', diet, ['Healthy', 'Average', 'Unhealthy'], (val) => setState(() => diet = val)),
              buildDropdown<int>('Önceki Kalp Sorunları (1=Evet, 0=Hayır)', previousHeartProblems, [0,1], (val) => setState(() => previousHeartProblems = val)),
              buildDropdown<int>('İlaç Kullanımı (1=Evet, 0=Hayır)', medicationUse, [0,1], (val) => setState(() => medicationUse = val)),
              buildDropdown<int>('Stres Seviyesi (1-10)', stressLevel, List.generate(10, (i) => i + 1), (val) => setState(() => stressLevel = val)),
              buildTextField('Günlük Hareketsiz Saat', sedentaryHours, (val) => sedentaryHours = val, keyboardType: TextInputType.number, validator: (val) => (val == null || val.isEmpty) ? 'Hareketsiz saat giriniz' : null),
              buildTextField('Gelir Düzeyi', income, (val) => income = val, validator: (val) => (val == null || val.isEmpty) ? 'Gelir düzeyi giriniz' : null),

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isLoading ? null : predict,
                child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Tahmin Yap'),
              ),

              const SizedBox(height: 20),
              if (predictionResult != null)
                Center(child: Text(predictionResult!, style: const TextStyle(fontSize: 18))),
            ],
          ),
        ),
      ),
    );
  }
}