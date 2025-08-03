import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DiabetesModelScreen extends StatefulWidget {
  const DiabetesModelScreen({super.key});

  @override
  _DiabetesModelScreenState createState() => _DiabetesModelScreenState();
}

class _DiabetesModelScreenState extends State<DiabetesModelScreen> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingController'lar
  final bmiController = TextEditingController();
  final mentHlthController = TextEditingController();
  final physHlthController = TextEditingController();

  // Dropdown veya Switch ile seçilecek değişkenler
  int highBP = 0; // 0: Hayır, 1: Evet
  int highChol = 0; // 0: Hayır, 1: Evet
  int heartDisease = 0; // 0: Hayır, 1: Evet
  int physActivity = 1; // 0: Hayır, 1: Evet
  int age = 7; // Örnek: 7 = 55-59 yaş grubu
  int genHlth = 3; // Örnek: 3 = İyi
  int education = 4; // Örnek: 4 = Lise Mezunu
  int income = 5; // Örnek: 5 = 25K-35K USD

  bool isLoading = false;
  String? sonuc;

  // Hugging Face Space API endpoint
  final String apiUrl = 'https://hyerdrac-yzta-group14-diabetes-model-test.hf.space/gradio_api/call/predict';

  // Polling URL base
  final String pollingUrlBase = 'https://hyerdrac-yzta-group14-diabetes-model-test.hf.space/gradio_api/call/predict/';

  // API Token (varsa)
  final String? hfApiToken = null;

  Future<void> tahminYap() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        sonuc = 'Lütfen tüm zorunlu alanları doldurun.';
      });
      return;
    }

    final double? bmi = double.tryParse(bmiController.text);
    final double? mentHlth = int.tryParse(mentHlthController.text)?.toDouble();
    final double? physHlth = int.tryParse(physHlthController.text)?.toDouble();

    if (bmi == null || mentHlth == null || physHlth == null) {
      setState(() {
        sonuc = 'Lütfen sayısal alanlara geçerli değerler girin.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      sonuc = null;
    });

    try {
      final List<double> inputFeatures = [
        bmi,
        mentHlth,
        physHlth,
        highBP.toDouble(),
        highChol.toDouble(),
        heartDisease.toDouble(),
        physActivity.toDouble(),
        age.toDouble(),
        genHlth.toDouble(),
        education.toDouble(),
        income.toDouble(),
      ];

      final bodyData = {
        "data": inputFeatures,
      };

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      if (hfApiToken != null && hfApiToken!.isNotEmpty) {
        headers['Authorization'] = 'Bearer $hfApiToken';
      }

      final initialResponse = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(bodyData),
      ).timeout(const Duration(seconds: 15));

      if (initialResponse.statusCode == 200) {
        final initialResult = jsonDecode(initialResponse.body);

        if (initialResult is Map<String, dynamic> && initialResult.containsKey('event_id')) {
          final String eventId = initialResult['event_id'];
          await _pollForPrediction(eventId, headers);
        } else {
          setState(() {
            sonuc = 'API yanıtında event_id bulunamadı: ${initialResponse.body}';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          sonuc = 'Sunucu hatası: ${initialResponse.statusCode}\nYanıt: ${initialResponse.body}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        sonuc = 'Bağlantı hatası veya zaman aşımı: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _pollForPrediction(String eventId, Map<String, String> headers) async {
    const int maxAttempts = 60;
    const Duration delay = Duration(seconds: 1);

    for (int i = 0; i < maxAttempts; i++) {
      await Future.delayed(delay);

      try {
        final pollingUrl = '$pollingUrlBase$eventId';

        final pollingResponse = await http.get(
          Uri.parse(pollingUrl),
          headers: headers,
        ).timeout(const Duration(seconds: 10));

        if (pollingResponse.statusCode == 200) {
          final String rawBody = pollingResponse.body;

          String? eventType;
          String? jsonDataString;

          final List<String> lines = rawBody.split('\n');
          for (final line in lines) {
            if (line.startsWith('event:')) {
              eventType = line.substring('event:'.length).trim();
            } else if (line.startsWith('data:')) {
              jsonDataString = line.substring('data:'.length).trim();
            }
          }

          if (eventType == null) {
            setState(() {
              sonuc = 'Polling yanıtında "event" satırı yok.';
              isLoading = false;
            });
            return;
          }

          if (jsonDataString == null || jsonDataString.isEmpty) {
            setState(() {
              sonuc = 'Polling yanıtında "data:" satırı boş.';
              isLoading = false;
            });
            return;
          }

          if (eventType == 'complete') {
            final List<dynamic> predictionArray = jsonDecode(jsonDataString);
            if (predictionArray.isNotEmpty) {
              final String finalPrediction = predictionArray[0].toString();
              setState(() {
                sonuc = finalPrediction;
                isLoading = false;
              });
              return;
            } else {
              setState(() {
                sonuc = 'Boş tahmin verisi alındı.';
                isLoading = false;
              });
              return;
            }
          } else if (eventType == 'status') {
            final Map<String, dynamic> statusData = jsonDecode(jsonDataString);
            if (statusData.containsKey('status')) {
              final String status = statusData['status'];
              if (status == 'QUEUED' || status == 'PENDING' || status == 'PROCESSING') {
                continue;
              } else {
                setState(() {
                  sonuc = 'Bilinmeyen durum: $status';
                  isLoading = false;
                });
                return;
              }
            } else {
              setState(() {
                sonuc = '"status" anahtarı polling yanıtında bulunamadı.';
                isLoading = false;
              });
              return;
            }
          } else {
            continue; // Beklenmedik event, devam et
          }
        } else {
          setState(() {
            sonuc = 'Polling sunucu hatası: ${pollingResponse.statusCode}';
            isLoading = false;
          });
          return;
        }
      } catch (e) {
        setState(() {
          sonuc = 'Polling bağlantı hatası: $e';
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

  Widget _buildDropdown({
    required String label,
    required int currentValue,
    required List<Map<String, dynamic>> items,
    required ValueChanged<int> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<int>(
        value: currentValue,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
        onChanged: (int? newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
        items: items.map<DropdownMenuItem<int>>((item) {
          return DropdownMenuItem<int>(
            value: item['value'] as int,
            child: Text(item['text'].toString()),
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    bmiController.dispose();
    mentHlthController.dispose();
    physHlthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Diyabet Tahmin Uygulaması")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: bmiController,
                decoration: const InputDecoration(
                  labelText: "BMI (Beden Kitle İndeksi, örn. 22.5)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen BMI değerini girin.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Geçerli bir sayı girin.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: mentHlthController,
                decoration: const InputDecoration(
                  labelText: "Son 30 günde kötü zihinsel sağlıkta geçen gün sayısı (0-30)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen gün sayısını girin.';
                  }
                  final int? val = int.tryParse(value);
                  if (val == null || val < 0 || val > 30) {
                    return '0-30 arasında bir tam sayı girin.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: physHlthController,
                decoration: const InputDecoration(
                  labelText: "Son 30 günde fiziksel sağlık problemi yaşadığınız gün sayısı (0-30)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen gün sayısını girin.';
                  }
                  final int? val = int.tryParse(value);
                  if (val == null || val < 0 || val > 30) {
                    return '0-30 arasında bir tam sayı girin.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildDropdown(
                label: "Yüksek Tansiyon Teşhisi",
                currentValue: highBP,
                items: const [
                  {'value': 0, 'text': 'Hayır'},
                  {'value': 1, 'text': 'Evet'},
                ],
                onChanged: (val) => setState(() => highBP = val),
              ),
              _buildDropdown(
                label: "Yüksek Kolesterol Teşhisi",
                currentValue: highChol,
                items: const [
                  {'value': 0, 'text': 'Hayır'},
                  {'value': 1, 'text': 'Evet'},
                ],
                onChanged: (val) => setState(() => highChol = val),
              ),
              _buildDropdown(
                label: "Kalp Hastalığı, Kalp Krizi veya Anjina Öyküsü",
                currentValue: heartDisease,
                items: const [
                  {'value': 0, 'text': 'Hayır'},
                  {'value': 1, 'text': 'Evet'},
                ],
                onChanged: (val) => setState(() => heartDisease = val),
              ),
              _buildDropdown(
                label: "Son 30 Günde Düzenli Fiziksel Aktivite",
                currentValue: physActivity,
                items: const [
                  {'value': 0, 'text': 'Hayır'},
                  {'value': 1, 'text': 'Evet'},
                ],
                onChanged: (val) => setState(() => physActivity = val),
              ),
              _buildDropdown(
                label: "Yaş Grubu",
                currentValue: age,
                items: const [
                  {'value': 1, 'text': '18-24'}, {'value': 2, 'text': '25-29'},
                  {'value': 3, 'text': '30-34'}, {'value': 4, 'text': '35-39'},
                  {'value': 5, 'text': '40-44'}, {'value': 6, 'text': '45-49'},
                  {'value': 7, 'text': '50-54'}, {'value': 8, 'text': '55-59'},
                  {'value': 9, 'text': '60-64'}, {'value': 10, 'text': '65-69'},
                  {'value': 11, 'text': '70-74'}, {'value': 12, 'text': '75-79'},
                  {'value': 13, 'text': '80+'},
                ],
                onChanged: (val) => setState(() => age = val),
              ),
              _buildDropdown(
                label: "Genel Sağlık Durumu",
                currentValue: genHlth,
                items: const [
                  {'value': 1, 'text': 'Mükemmel'}, {'value': 2, 'text': 'Çok İyi'},
                  {'value': 3, 'text': 'İyi'}, {'value': 4, 'text': 'Orta'},
                  {'value': 5, 'text': 'Kötü'},
                ],
                onChanged: (val) => setState(() => genHlth = val),
              ),
              _buildDropdown(
                label: "Eğitim Seviyesi",
                currentValue: education,
                items: const [
                  {'value': 1, 'text': 'İlkokul ve altı'},
                  {'value': 2, 'text': 'Bazı Lise'},
                  {'value': 3, 'text': 'Lise Mezunu'},
                  {'value': 4, 'text': 'Bazı Üniversite veya Teknik Okul'},
                  {'value': 5, 'text': 'Üniversite Mezunu'},
                  {'value': 6, 'text': 'Üniversite Üstü'},
                ],
                onChanged: (val) => setState(() => education = val),
              ),
              _buildDropdown(
                label: "Yıllık Gelir Seviyesi",
                currentValue: income,
                items: const [
                  {'value': 1, 'text': '<10K USD'}, {'value': 2, 'text': '10K-15K USD'},
                  {'value': 3, 'text': '15K-20K USD'}, {'value': 4, 'text': '20K-25K USD'},
                  {'value': 5, 'text': '25K-35K USD'}, {'value': 6, 'text': '35K-50K USD'},
                  {'value': 7, 'text': '50K-75K USD'}, {'value': 8, 'text': '>75K USD'},
                ],
                onChanged: (val) => setState(() => income = val),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : tahminYap,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Tahmin Yap"),
              ),
              const SizedBox(height: 20),
              if (isLoading)
                const Center(child: CircularProgressIndicator()),
              if (sonuc != null)
                Center(
                  child: Text(
                    sonuc!,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}