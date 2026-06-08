// lib/goals_screen.dart
import 'package:flutter/material.dart';
import 'models.dart'; // Імпортуємо структуру пацієнта

class EmbeddedSmartGoalsScreen extends StatefulWidget {
  final List<PatientCard> patients;
  final VoidCallback onGoalSaved;

  const EmbeddedSmartGoalsScreen({Key? key, required this.patients, required this.onGoalSaved}) : super(key: key);

  @override
  State<EmbeddedSmartGoalsScreen> createState() => _EmbeddedSmartGoalsScreenState();
}

class _EmbeddedSmartGoalsScreenState extends State<EmbeddedSmartGoalsScreen> {
  PatientCard? _selectedPatient;

  final Map<String, TextEditingController> _controllers = {
    "S": TextEditingController(), "M": TextEditingController(), "A": TextEditingController(), "R": TextEditingController(), "T": TextEditingController(),
  };

  final List<Map<String, String>> _fields = [
    {"key": "S", "t": "S - Специфічна (Specific)", "h": "Яку функцію/дію відновлюємо?"},
    {"key": "M", "t": "M - Вимірювана (Measurable)", "h": "Показник в метрах, градусах або балах"},
    {"key": "A", "t": "A - Досяжна (Achievable)", "h": "Реалістичність мети для пацієнта"},
    {"key": "R", "t": "R - Релевантна (Relevant)", "h": "Важливість цілі для життєдіяльності"},
    {"key": "T", "t": "T - Обмежена в часі (Time-bound)", "h": "Термін досягнення (наприклад: 2 тижні)"},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.patients.isNotEmpty) {
      _selectedPatient = widget.patients.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Конструктор цілей SMART"), backgroundColor: Colors.green.shade600, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Крок 1: Оберіть пацієнта для цілі", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(8), color: Colors.white),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<PatientCard>(
                  value: _selectedPatient,
                  isExpanded: true,
                  hint: const Text("Виберіть карту пацієнта"),
                  items: widget.patients.map((PatientCard p) {
                    return DropdownMenuItem<PatientCard>(value: p, child: Text(p.fullName, style: const TextStyle(fontSize: 14)));
                  }).toList(),
                  onChanged: (PatientCard? val) => setState(() => _selectedPatient = val),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Крок 2: Формування критеріїв цілі", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Expanded(
              child: ListView.builder(
                itemCount: _fields.length,
                itemBuilder: (context, index) {
                  final f = _fields[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: TextField(
                      controller: _controllers[f["key"]],
                      decoration: InputDecoration(
                        labelText: f["t"], hintText: f["h"],
                        labelStyle: const TextStyle(fontSize: 12),
                        hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600),
                onPressed: () {
                  if (_selectedPatient == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Спершу оберіть пацієнта")));
                    return;
                  }
                  if (_controllers["S"]!.text.isEmpty || _controllers["T"]!.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Критерії (S) та (T) є обов'язковими")));
                    return;
                  }

                  String goalText = "Ціль: ${_controllers["S"]!.text} "
                      "(${_controllers["M"]!.text.isEmpty ? 'без індикатора' : _controllers["M"]!.text}). "
                      "Термін: ${_controllers["T"]!.text}.";

                  _selectedPatient!.smartGoals.add(goalText);
                  widget.onGoalSaved();

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ціль додано до карти: ${_selectedPatient!.fullName}")));
                  for (var c in _controllers.values) { c.clear(); }
                },
                child: const Text("Зберегти ціль в карту пацієнта", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
