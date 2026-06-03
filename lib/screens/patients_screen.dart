import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models.dart';
import 'mkh10_screen.dart';
import 'scales_catalog_screen.dart';
import 'exercises_screen.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final List<Patient> _patients = [
    Patient(
      id: '1',
      name: 'Іваненко Петро Миколайович',
      birthDate: '14.05.1974',
      diagnosisMkh10: '[I63] Інфаркт мозку (Ішемічний інсульт)',
      admissionDate: '20.05.2026',
      irp: IrpPlan(
        goalsSmart: 'Збільшити силу в паретичній правій нозі до 4 балів за MRC та самостійно проходити 50 метрів без опори до 15.07.2026.',
        mfkCodes: 'b730.2 (Помірне порушення сили м\'язів однієї половини тіла), d450.1 (Легке ускладнення ходьби).',
        rehabilitationCycle: 'Первинний',
        interventionPlan: 'Кінезіотерапія за методикою PNF, ортостатичні тренування, відновлення дрібної моторики кисті.',
        specialistName: 'Ковальчук О.В.',
      ),
    ),
  ];

  final _nameController = TextEditingController();
  final _birthController = TextEditingController();
  final _admissionController = TextEditingController();
  String _selectedDiagnosis = 'Не вказано. Натисніть кнопку МКХ-10';

  void _addNewPatient() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Створити картку пацієнта', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'ПІБ Пацієнта')),
                    TextField(controller: _birthController, decoration: const InputDecoration(labelText: 'Дата народження (ДД.ММ.РРРР)')),
                    TextField(controller: _admissionController, decoration: const InputDecoration(labelText: 'Дата початку реабілітації')),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(border: Border.all(color: Colors.purple.shade200), borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Діагноз за МКХ-10:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.purple)),
                          const SizedBox(height: 4),
                          Text(_selectedDiagnosis, style: const TextStyle(fontSize: 13)),
                          const SizedBox(height: 6),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple.shade400, foregroundColor: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Mkh10Screen(
                                    onSelectDiagnosis: (diag) {
                                      setDialogState(() {
                                        _selectedDiagnosis = diag;
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.search),
                            label: const Text('Відкрити МКХ-10'),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Скасувати')),
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isNotEmpty) {
                      setState(() {
                        _patients.add(Patient(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: _nameController.text,
                          birthDate: _birthController.text,
                          diagnosisMkh10: _selectedDiagnosis,
                          admissionDate: _admissionController.text,
                          irp: IrpPlan(),
                        ));
                      });
                      _nameController.clear();
                      _birthController.clear();
                      _admissionController.clear();
                      _selectedDiagnosis = 'Не вказано. Натисніть кнопку МКХ-10';
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Зберегти'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Реєстр / Картки пацієнтів'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: ListView.builder(
        itemCount: _patients.length,
        itemBuilder: (context, index) {
          final patient = _patients[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.assignment_ind, size: 40, color: Colors.blue),
              title: Text(patient.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Діагноз: ${patient.diagnosisMkh10}\nВізитів: ${patient.visits.length}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PatientCardDetailScreen(patient: patient, onUpdate: () => setState(() {}))),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewPatient,
        label: const Text('Новий пацієнт', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.person_add),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class PatientCardDetailScreen extends StatefulWidget {
  final Patient patient;
  final VoidCallback onUpdate;

  const PatientCardDetailScreen({super.key, required this.patient, required this.onUpdate});

  @override
  State<PatientCardDetailScreen> createState() => _PatientCardDetailScreenState();
}

class _PatientCardDetailScreenState extends State<PatientCardDetailScreen> {
  void _createNewVisit() {
    setState(() {
      widget.patient.visits.add(PatientVisit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.now(),
        therapeuticNote: 'Стан стабільний. Проведено планові втручання.',
      ));
    });
    widget.onUpdate();
  }

  void _shareMoxReport() {
    final reportText = widget.patient.generateMoxStatement();
    Share.share(reportText, subject: 'Реабілітаційна виписка МОЗ — ${widget.patient.name}');
  }

  @override
  Widget build(BuildContext context) {
    final patient = widget.patient;
    return Scaffold(
      appBar: AppBar(
        title: Text(patient.name),
        backgroundColor: Colors.teal.shade100,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            tooltip: 'Поділитися випискою МОЗ (Viber/Telegram/Google Drive)',
            onPressed: _shareMoxReport,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.teal.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Діагноз за МКХ-10: ${patient.diagnosisMkh10}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('Дата народження: ${patient.birthDate} | Початок: ${patient.admissionDate}', style: const TextStyle(fontSize: 13, color: Colors.black87)),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Історія візитів та тестувань:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                    onPressed: _createNewVisit,
                    icon: const Icon(Icons.add),
                    label: const Text('Зафіксувати візит'),
                  )
                ],
              ),
            ),

            if (patient.visits.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('Жодного візиту ще не додано. Натисніть кнопку "Зафіксувати візит" вище.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: patient.visits.length,
                itemBuilder: (context, vIndex) {
                  final visit = patient.visits[vIndex];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    color: Colors.grey.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Візит №${vIndex + 1} від ${visit.date.day}.${visit.date.month}.${visit.date.year}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                              const Icon(Icons.edit_note, color: Colors.grey),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            initialValue: visit.therapeuticNote,
                            decoration: const InputDecoration(labelText: 'Статус / Щоденник візиту', border: OutlineInputBorder()),
                            maxLines: null,
                            onChanged: (text) {
                              visit.therapeuticNote = text;
                              widget.onUpdate();
                            },
                          ),
                          const SizedBox(height: 12),
                          
                          if (visit.testResults.isNotEmpty) ...[
                            const Text('Проведені тестування за шкалами:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ...visit.testResults.entries.map((e) => Text('• ${e.key}: ${e.value}', style: const TextStyle(fontSize: 13, color: Colors.blue, fontWeight: FontWeight.w600))),
                            const SizedBox(height: 10),
                          ],

                          if (visit.assignedExercises.isNotEmpty) ...[
                            const Text('Призначені вправи:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ...visit.assignedExercises.map((exName) => Text('• $exName', style: const TextStyle(fontSize: 13, color: Colors.green))),
                            const SizedBox(height: 10),
                          ],

                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 8)),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ScalesCatalogScreen(
                                          onScaleTested: (scaleName, result) {
                                            setState(() {
                                              visit.testResults[scaleName] = result;
                                            });
                                            widget.onUpdate();
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.analytics, size: 16),
                                  label: const Text('Провести тест', style: TextStyle(fontSize: 11)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 8)),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ExercisesScreen(
                                          onSelectExercise: (exName) {
                                            setState(() {
                                              if (!visit.assignedExercises.contains(exName)) {
                                                visit.assignedExercises.add(exName);
                                              }
                                            });
                                            widget.onUpdate();
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.fitness_center, size: 16),
                                  label: const Text('+ Вправу', style: TextStyle(fontSize: 11)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
