// lib/icd_screen.dart
import 'package:flutter/material.dart';
import 'models.dart'; // Імпортуємо структуру пацієнта

class EmbeddedIcdScreen extends StatefulWidget {
  final List<PatientCard> patients;
  final VoidCallback onIcdAssigned;

  const EmbeddedIcdScreen({Key? key, required this.patients, required this.onIcdAssigned}) : super(key: key);

  @override
  State<EmbeddedIcdScreen> createState() => _EmbeddedIcdScreenState();
}

class _EmbeddedIcdScreenState extends State<EmbeddedIcdScreen> {
  String _searchQuery = "";
  PatientCard? _targetPatient;

  final List<Map<String, String>> _icdCodes = [
    {"code": "I69.3", "name": "Наслідки ішемічного інсульту головного мозку"},
    {"code": "G80.0", "name": "Спастичний церебральний параліч (ДЦП)"},
    {"code": "M16.0", "name": "Первинний коксартроз двобічний"},
    {"code": "M50.1", "name": "Ураження міжхребцевого диска шийного відділу з радикулопатією"},
    {"code": "S42.2", "name": "Перелом верхнього кінця плечової кістки"},
    {"code": "T90.5", "name": "Наслідки внутрішньочерепної травми"},
    {"code": "S32.0", "name": "Перелом поперекового хребця L1"},
    {"code": "G20", "name": "Хвороба Паркінсона"},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.patients.isNotEmpty) {
      _targetPatient = widget.patients.first;
    }
  }

  void _assignCode(String code) {
    if (_targetPatient == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Спершу виберіть або додайте пацієнта")));
      return;
    }

    if (_targetPatient!.icdCodes.contains(code)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Код $code вже є у картці пацієнта!")));
      return;
    }

    setState(() { _targetPatient!.icdCodes.add(code); });
    widget.onIcdAssigned();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Код $code успішно закріплено за пацієнтом: ${_targetPatient!.fullName}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _icdCodes.where((e) {
      return e["code"]!.toLowerCase().contains(_searchQuery.toLowerCase()) || e["name"]!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Довідник МКХ-10"), backgroundColor: Colors.amber.shade700, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Оберіть пацієнта для призначення коду:", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(8), color: Colors.white),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<PatientCard>(
                  value: _targetPatient,
                  isExpanded: true,
                  items: widget.patients.map((PatientCard p) {
                    return DropdownMenuItem<PatientCard>(value: p, child: Text(p.fullName, style: const TextStyle(fontSize: 13)));
                  }).toList(),
                  onChanged: (val) => setState(() => _targetPatient = val),
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              decoration: const InputDecoration(labelText: "Швидкий пошук за діагнозом чи кодом МКХ", prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text("Кодів за запитом не знайдено"))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final codeItem = filtered[index];
                        return Card(
                          child: ListTile(
                            leading: Chip(label: Text(codeItem["code"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)), backgroundColor: Colors.amber.shade100),
                            title: Text(codeItem["name"]!, style: const TextStyle(fontSize: 13)),
                            trailing: const Icon(Icons.add_link, color: Colors.amber),
                            onTap: () => _assignCode(codeItem["code"]!),
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
