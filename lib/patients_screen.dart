// lib/patients_screen.dart
import 'package:flutter/material.dart';
import 'models.dart'; // Імпортуємо структуру пацієнта

class PatientsRegistryScreen extends StatefulWidget {
  final List<PatientCard> patients;
  final Function(PatientCard) onPatientAdded;
  final Function(int) onPatientDeleted;

  const PatientsRegistryScreen({
    Key? key,
    required this.patients,
    required this.onPatientAdded,
    required this.onPatientDeleted,
  }) : super(key: key);

  @override
  State<PatientsRegistryScreen> createState() => _PatientsRegistryScreenState();
}

class _PatientsRegistryScreenState extends State<PatientsRegistryScreen> {
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _diagnosisController = TextEditingController();

  void _createNewPatient() {
    if (_nameController.text.isEmpty || _diagnosisController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ПІБ та Первинний діагноз є обов'язаковими")),
      );
      return;
    }

    final newPatient = PatientCard(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: _nameController.text,
      birthDate: _dateController.text.isEmpty ? "Не вказано" : _dateController.text,
      primaryDiagnosis: _diagnosisController.text,
      smartGoals: [],
      icdCodes: [],
      assignedExercises: [],
    );

    widget.onPatientAdded(newPatient);

    _nameController.clear();
    _dateController.clear();
    _diagnosisController.clear();
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Медичну картку пацієнта створено успішно")),
    );
  }

  void _openAddPatientSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 20, left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Нова медична картка пацієнта", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
              const Divider(),
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: "ПІБ пацієнта *", border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(controller: _dateController, decoration: const InputDecoration(labelText: "Дата народження", hintText: "ДД.ММ.РРРР", border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(controller: _diagnosisController, maxLines: 2, decoration: const InputDecoration(labelText: "Первинний клінічний діагноз *", border: OutlineInputBorder())),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey), onPressed: () => Navigator.pop(context), child: const Text("Скасувати", style: TextStyle(color: Colors.white)))),
                  const SizedBox(width: 10),
                  Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700), onPressed: _createNewPatient, child: const Text("Створити карту", style: TextStyle(color: Colors.white)))),
                ],
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  void _showPatientCardDetails(PatientCard patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(patient.fullName, style: const TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text("🎂 Дата народження: ${patient.birthDate}", style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 5),
              Text("🩺 Діагноз: ${patient.primaryDiagnosis}", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const Divider(),
              
              const Text("📌 Закріплені коди МКХ-10:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.amber)),
              patient.icdCodes.isEmpty 
                ? const Text("Коди не призначені", style: TextStyle(fontSize: 11, color: Colors.grey))
                : Wrap(spacing: 4, children: patient.icdCodes.map((c) => Chip(label: Text(c, style: const TextStyle(fontSize: 11)))).toList()),
              const Divider(),

              const Text("🎯 Встановлені цілі SMART:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.green)),
              patient.smartGoals.isEmpty
                ? const Text("Цілі не сформульовані", style: TextStyle(fontSize: 11, color: Colors.grey))
                : Column(crossAxisAlignment: CrossAxisAlignment.start, children: patient.smartGoals.map((g) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Text("• $g", style: const TextStyle(fontSize: 11)))).toList()),
              const Divider(),

              const Text("🏋️‍♂️ Призначена програма ЛФК:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.purple)),
              patient.assignedExercises.isEmpty
                ? const Text("Вправи не додані", style: TextStyle(fontSize: 11, color: Colors.grey))
                : Column(crossAxisAlignment: CrossAxisAlignment.start, children: patient.assignedExercises.map((e) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Text("✔ $e", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)))).toList()),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Закрити"))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Реєстр пацієнтів"), backgroundColor: Colors.blue.shade700, foregroundColor: Colors.white),
      body: widget.patients.isEmpty
          ? const Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text("Реєстр порожній. Натисніть '+', щоб створити першу карту пацієнта.", textAlign: TextAlign.center)))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: widget.patients.length,
              itemBuilder: (context, index) {
                final patient = widget.patients[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: Colors.blue.shade100, child: const Icon(Icons.person, color: Colors.blue)),
                    title: Text(patient.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Text("Діагноз: ${patient.primaryDiagnosis}", maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                      onPressed: () => widget.onPatientDeleted(index),
                    ),
                    onTap: () => _showPatientCardDetails(patient),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
        onPressed: _openAddPatientSheet,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
