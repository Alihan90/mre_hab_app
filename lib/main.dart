import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const RehabApp());
}

class RehabApp extends StatelessWidget {
  const RehabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Фізична Терапія & Реабілітація',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const PatientListScreen(),
    );
  }
}

// Модель даних пацієнта
class Patient {
  final String id;
  final String name;
  final String diagnosis;
  final Map<String, String> scaleResults;

  Patient({
    required this.id,
    required this.name,
    required this.diagnosis,
    required this.scaleResults,
  });
}

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  // Початковий список пацієнтів для прикладу
  final List<Patient> _patients = [
    Patient(
      id: '1',
      name: 'Іванов Петро Миколайович',
      diagnosis: 'Стан після ІГМ (Інсульту), лівобічний геміпарез',
      scaleResults: {'MRC-SumScore': '42/60'},
    ),
    Patient(
      id: '2',
      name: 'Сидоров Олег Васильович',
      diagnosis: 'ЧМТ, порушення координації та балансу',
      scaleResults: {},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Пацієнти реабілітації'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: ListView.builder(
        itemCount: _patients.count == 0 ? 0 : _patients.length,
        itemBuilder: (context, index) {
          final patient = _patients[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(patient.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Діагноз: ${patient.diagnosis}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientCardScreen(patient: patient),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Картка пацієнта та доступні шкали
class PatientCardScreen extends StatelessWidget {
  final Patient patient;
  const PatientCardScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Картка пацієнта'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(patient.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 8),
            Text('Діагноз: ${patient.diagnosis}', style: const TextStyle(fontSize: 16)),
            const Divider(height: 32),
            const Text('Клінічні оцінювальні шкали:', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            // Список доступних шкал для тестування
            Card(
              color: Colors.blue.shade50,
              child: ListTile(
                leading: const Icon(Icons.accessibility_new, color: Colors.blue),
                title: const Text('Шкала MRC-SumScore'),
                subtitle: Text(patient.scaleResults.containsKey('MRC-SumScore') 
                  ? 'Останній результат: ${patient.scaleResults['MRC-SumScore']}'
                  : 'Тестування не проводилось'),
                trailing: const Icon(Icons.play_arrow, color: Colors.blue),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MrcScaleScreen(patient: patient),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Екран тестування за шкалою MRC-SumScore з вбудованою інструкцією
class MrcScaleScreen extends StatefulWidget {
  final Patient patient;
  const MrcScaleScreen({super.key, required this.patient});

  @override
  State<MrcScaleScreen> createState() => _MrcScaleScreenState();
}

class _MrcScaleScreenState extends State<MrcScaleScreen> {
  // Значення балів для 6 груп м'язів (справа та зліва)
  Map<String, int> scores = {
    'Abductors of arm (R)': 5, 'Abductors of arm (L)': 5,
    'Flexors of forearm (R)': 5, 'Flexors of forearm (L)': 5,
    'Extensors of wrist (R)': 5, 'Extensors of wrist (L)': 5,
    'Flexors of hip (R)': 5, 'Flexors of hip (L)': 5,
    'Extensors of knee (R)': 5, 'Extensors of knee (L)': 5,
    'Dorsiflexors of foot (R)': 5, 'Dorsiflexors of foot (L)': 5,
  };

  int get totalScore => scores.values.fold(0, (sum, item) => sum + item);

  void _shareResult() {
    final text = 'Результат тестування пацієнта ${widget.patient.name}\n'
        'Шкала: MRC-SumScore\n'
        'Загальний бал: $totalScore з 60';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Тестування: MRC-SumScore'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareResult,
          )
        ],
      ),
      body: Column(
        children: [
          // ВБУДОВАНА ІНСТРУКЦІЯ ДЛЯ ТЕРАПЕВТА
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.amber.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber.shade900),
                    const SizedBox(width: 8),
                    const Text('Методична довідка терапевта', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Навіщо: Оцінка загальної сили м’язів у пацієнтів з парезами (напр. після інсульту).\n'
                  'Як проводити: Оцініть 6 груп м’язів праворуч та ліворуч від 0 до 5 балів:\n'
                  ' • 5 — Нормальна сила\n'
                  ' • 4 — Рух проти помірного опору\n'
                  ' • 3 — Рух проти сили тяжіння, але без опору\n'
                  ' • 2 — Рух у площині столу (без сили тяжіння)\n'
                  ' • 1 — Скорочення м’яза без видимого руху\n'
                  ' • 0 — Жодного скорочення',
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ],
            ),
          ),
          
          // Результат в реальному часі
          Padding(
            padding: const EdgeInsets.all(16.0),
            key: const ValueKey('score_summary'),
            child: Text(
              'Загальний бал: $totalScore / 60',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          
          // Список м'язових груп для виставлення балів
          Expanded(
            child: ListView(
              children: scores.keys.map((String key) {
                return ListTile(
                  title: Text(key),
                  trailing: DropdownButton<int>(
                    value: scores[key],
                    items: [0, 1, 2, 3, 4, 5].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value балів'),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() {
                          scores[key] = newValue;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
