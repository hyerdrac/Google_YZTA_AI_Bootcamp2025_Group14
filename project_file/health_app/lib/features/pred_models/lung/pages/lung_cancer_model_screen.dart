import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LungCancerScreen extends StatefulWidget {
  const LungCancerScreen({super.key});

  @override
  State<LungCancerScreen> createState() => _LungCancerScreenState();
}

class _LungCancerScreenState extends State<LungCancerScreen> {
  final _formKey = GlobalKey<FormState>();

  String gender = 'M';
  String age = '';
  int smoking = 1;
  int yellowFingers = 1;
  int anxiety = 1;
  int peerPressure = 1;
  int chronicDisease = 1;
  int fatigue = 1;
  int allergy = 1;
  int wheezing = 1;
  int alcoholConsuming = 1;
  int coughing = 1;
  int shortnessOfBreath = 1;
  int swallowingDifficulty = 1;
  int chestPain = 1;

  String? sonuc;
  bool isLoading = false;

  final String apiUrl = 'https://hyerdrac-yzta-group14-lung-cancer-model.hf.space/gradio_api/call/predict';
  final String pollingBase = 'https://hyerdrac-yzta-group14-lung-cancer-model.hf.space/gradio_api/call/predict/';
  final String? hfApiToken = null; // varsa buraya ekle

  Future<void> tahminYap() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      sonuc = null;
    });

    try {
      final inputData = {
        "data": [
          gender,
          int.parse(age),
          smoking,
          yellowFingers,
          anxiety,
          peerPressure,
          chronicDisease,
          fatigue,
          allergy,
          wheezing,
          alcoholConsuming,
          coughing,
          shortnessOfBreath,
          swallowingDifficulty,
          chestPain
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
        await _pollResult(eventId, headers);
      } else {
        setState(() {
          sonuc = 'Sunucu hatası: ${response.statusCode}\nYanıt: ${response.body}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        sonuc = 'Bağlantı hatası veya format hatası: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _pollResult(String eventId, Map<String, String> headers) async {
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
              sonuc = 'Tahmin sonucu: ${result[0]}';
              isLoading = false;
            });
            return;
          }
        } else {
          setState(() {
            sonuc = 'Polling hatası: ${response.statusCode}';
            isLoading = false;
          });
          return;
        }
      } catch (e) {
        setState(() {
          sonuc = 'Polling hatası: $e';
          isLoading = false;
        });
        return;
      }
    }

    setState(() {
      sonuc = 'Tahmin zaman aşımına uğradı.';
      isLoading = false;
    });
  }

  Widget _buildDropdown(String label, int value, ValueChanged<int> onChanged) {
    return DropdownButtonFormField<int>(
      value: value,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      items: const [
        DropdownMenuItem(value: 1, child: Text('Hayır')),
        DropdownMenuItem(value: 2, child: Text('Evet')),
      ],
      onChanged: (val) => onChanged(val!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Akciğer Kanseri Tahmin')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: gender,
                decoration: const InputDecoration(labelText: "Cinsiyet", border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'M', child: Text('Erkek')),
                  DropdownMenuItem(value: 'F', child: Text('Kadın')),
                ],
                onChanged: (val) => setState(() => gender = val!),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: "Yaş", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.isEmpty ? 'Yaş giriniz' : null,
                onChanged: (val) => age = val,
              ),
              const SizedBox(height: 10),
              _buildDropdown("Sigara", smoking, (val) => setState(() => smoking = val)),
              _buildDropdown("Sarı Parmaklar", yellowFingers, (val) => setState(() => yellowFingers = val)),
              _buildDropdown("Anksiyete", anxiety, (val) => setState(() => anxiety = val)),
              _buildDropdown("Baskı", peerPressure, (val) => setState(() => peerPressure = val)),
              _buildDropdown("Kronik Hastalık", chronicDisease, (val) => setState(() => chronicDisease = val)),
              _buildDropdown("Yorgunluk", fatigue, (val) => setState(() => fatigue = val)),
              _buildDropdown("Alerji", allergy, (val) => setState(() => allergy = val)),
              _buildDropdown("Hırıltı", wheezing, (val) => setState(() => wheezing = val)),
              _buildDropdown("Alkol Tüketimi", alcoholConsuming, (val) => setState(() => alcoholConsuming = val)),
              _buildDropdown("Öksürük", coughing, (val) => setState(() => coughing = val)),
              _buildDropdown("Nefes Darlığı", shortnessOfBreath, (val) => setState(() => shortnessOfBreath = val)),
              _buildDropdown("Yutma Güçlüğü", swallowingDifficulty, (val) => setState(() => swallowingDifficulty = val)),
              _buildDropdown("Göğüs Ağrısı", chestPain, (val) => setState(() => chestPain = val)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isLoading ? null : tahminYap,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Tahmin Yap"),
              ),
              const SizedBox(height: 20),
              if (sonuc != null)
                Center(child: Text(sonuc!, style: const TextStyle(fontSize: 18))),
            ],
          ),
        ),
      ),
    );
  }
}