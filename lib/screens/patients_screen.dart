// lib/screens/patients_screen.dart
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models.dart';
import 'mkh10_screen.dart';
import 'scales_catalog_screen.dart';
import 'exercises_catalog_view.dart'; 

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
        plannedDays: 3,
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
      barrierDismissible: false, // Користувач має натиснути кнопки для закриття
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Створити картку пацієнта', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController, 
                      decoration: const InputDecoration(labelText: 'ПІБ Пацієнта (українською)'),
                    ),
                    TextField(
                      controller: _birthController, 
                      decoration: const InputDecoration(labelText: 'Дата народження (ДД.ММ.РРРР)'),
                    ),
                    TextField(
                      controller: _admissionController, 
                      decoration: const InputDecoration(labelText: 'Дата початку реабілітації'),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.purple.shade200), 
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Діагноз за МКХ-10:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.purple)),
                          const SizedBox(height: 4),
                          Text(_selectedDiagnosis, style: const TextStyle(fontSize: 13)),
                          const SizedBox(height: 6),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple.shade400, 
                              foregroundColor: Colors.white,
                            ),
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
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  }, 
                  child: const Text('Скасувати'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.trim().isNotEmpty) {
                      setState(() {
                        _patients.add(Patient(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: _nameController.text.trim(),
                          birthDate: _birthController.text.trim(),
                          diagnosisMkh10: _selectedDiagnosis,
                          admissionDate: _admissionController.text.trim(),
                          irp: IrpPlan(),
                        ));
                      });
                      _nameController.clear();
                      _birthController.clear();
                      _admissionController.clear();
                      _selectedDiagnosis = 'Не вказано. Натисніть кнопку МКХ-10';
                      Navigator.pop(dialogContext);
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
        leading: const BackButton(color: Colors.black), // Надійна системна кнопка назад
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
              subtitle: Text('Діагноз: ${patient.diagnosisMkh10}\nПлановий ІРП: ${patient.irp.plannedDays} днів | Візитів: ${patient.visits.length}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientCardDetailScreen(
                      patient: patient, 
                      onUpdate: () => setState(() {}),
                    ),
                  ),
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
  
  // Автоматичний клінічний підбір некопіювальних вправ на N днів за діагнозом
  void _generateSmartIrpSchedule() {
    final irp = widget.patient.irp;
    irp.daysSchedule.clear();

    List<String> matchingKeys = [];
    String diag = widget.patient.diagnosisMkh10.toLowerCase();

    if (diag.contains('i63') || diag.contains('інсульт') || diag.contains('невро')) {
      matchingKeys = ["NEURO_ADULT_01", "NEURO_ADULT_02", "NEURO_ADULT_03", "RESP_01"];
    } else if (diag.contains('m50') || diag.contains('орто') || diag.contains('перелом')) {
      matchingKeys = ["ORTHO_01", "ORTHO_02", "NEURO_ADULT_02"];
    } else if (diag.contains('дцп') || diag.contains('g80')) {
      matchingKeys = ["PEDS_01", "PEDS_02", "RESP_01"];
    } else {
      matchingKeys = ["RESP_01", "RESP_02", "GER_02"]; 
    }

    for (int day = 1; day <= irp.plannedDays; day++) {
      List<CustomExercise> dayExercises = [];
      
      if (day % 2 != 0) {
        if (matchingKeys.isNotEmpty) {
          var ex = exercisesRepository[matchingKeys[0]];
          if (ex != null) dayExercises.add(CustomExercise(id: ex.id, title: ex.title, dosage: ex.dosage));
        }
        if (matchingKeys.length > 2) {
          var ex = exercisesRepository[matchingKeys[2]];
          if (ex != null) dayExercises.add(CustomExercise(id: ex.id, title: ex.title, dosage: ex.dosage));
        }
      } else {
        if (matchingKeys.length > 1) {
          var ex = exercisesRepository[matchingKeys[1]];
          if (ex != null) dayExercises.add(CustomExercise(id: ex.id, title: ex.title, dosage: ex.dosage));
        }
        var extra = exercisesRepository["GER_02"];
        if (extra != null) dayExercises.add(CustomExercise(id: extra.id, title: extra.title, dosage: extra.dosage));
      }

      irp.daysSchedule[day] = dayExercises;
    }

    setState(() {});
    widget.onUpdate();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Згенеровано інтелектуальний графік на ${irp.plannedDays} днів за кодами МКХ-10!')),
    );
  }

  // Фіксація візиту з точним часом
  void _createNewVisit() {
    final now = DateTime.now();
    final timeString = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    setState(() {
      widget.patient.visits.add(PatientVisit(
        id: now.millisecondsSinceEpoch.toString(),
        date: now,
        therapeuticNote: '[$timeString] Проведено тренування за індивідуальним планом на сьогодні. Скарги відсутні.',
      ));
    });
    widget.onUpdate();
  }

  // Вікно для ручного редагування будь-якого текстового поля в ІРП або SMART
  void _editTextField(String title, String currentValue, Function(String) onSave) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Редагувати: $title'),
        content: TextField(controller: controller, maxLines: null, decoration: const InputDecoration(border: OutlineInputBorder())),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Скасувати')),
          ElevatedButton(
            onPressed: () {
              setState(() => onSave(controller.text));
              widget.onUpdate();
              Navigator.pop(context);
            },
            child: const Text('Зберегти'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final patient = widget.patient;
    final irp = patient.irp;

    return Scaffold(
      appBar: AppBar(
        title: Text(patient.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal.shade100,
        leading: const BackButton(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            tooltip: 'Поділитися формою ІРП МОЗ України',
            onPressed: () => Share.share(patient.generateMoxStatement(), subject: 'ІРП МОЗ — ${patient.name}'),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // БЛОК 1. КЛІНІЧНИЙ ПАСПОРТ ТА МКХ-10
            // ==========================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              color: Colors.teal.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text('Діагноз МКХ-10: ${patient.diagnosisMkh10}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18, color: Colors.teal),
                        onPressed: () => _editTextField(
                          'Діагноз МКХ-10', 
                          patient.diagnosisMkh10, 
                          (val) {
                            setState(() => patient.diagnosisMkh10 = val);
                            widget.onUpdate();
                          },
                        ),
                      )
                    ],
                  ),
                  Text('Дата народження: ${patient.birthDate}  |  Початок циклу: ${patient.admissionDate}', style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),

            // ==========================================
            // БЛОК 2. ДИНАМІЧНИЙ ГРАФІК СТАНУ ПАЦІЄНТА
            // ==========================================
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('📈 Клінічна динаміка стану (Шкали)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 6),
                      if (patient.scaleHistory == null || patient.scaleHistory.isEmpty)
                        const Text('Немає збережених точок тестування для графіка динаміки.', style: TextStyle(fontSize: 11, color: Colors.grey))
                      else ...[
                        Text('Остання оцінка: ${patient.scaleHistory.last.scaleName} -> ${patient.scaleHistory.last.score} балів', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Container(
                          height: 24,
                          width: double.infinity,
                          decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(6)),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: (patient.scaleHistory.last.score / 100).clamp(0.1, 1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [Colors.blue, Colors.green.shade400]),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(child: Text('${patient.scaleHistory.last.score.toInt()}% Функціоналу', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // ==========================================
            // БЛОК 3. SMART ЦІЛІ ТА МКФ (ВИПРАВЛЕНИЙ МАКЕТ)
            // ==========================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('🎯 Постановка цілей SMART (МОЗ)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20, color: Colors.indigo), 
                            onPressed: () => _editTextField('Ціль SMART', irp.goalsSmart, (val) => irp.goalsSmart = val),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        irp.goalsSmart.isEmpty ? 'Натисніть олівець, щоб сформулювати ціль...' : irp.goalsSmart, 
                        style: const TextStyle(fontSize: 13),
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('🧬 Коди МКФ:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.indigo)),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20, color: Colors.indigo), 
                            onPressed: () => _editTextField('МКФ коди', irp.mfkCodes, (val) => irp.mfkCodes = val),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        irp.mfkCodes.isEmpty ? 'Натисніть олівець, щоб додати коди МКФ...' : irp.mfkCodes, 
                        style: const TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ==========================================
            // БЛОК 4. АВТОМАТИЧНИЙ КОНСТРУКТОР ІРП (БЕЗПЕЧНИЙ)
            // ==========================================
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                // Оскільки shade50 обчислюється під час виконання, 
                // перед самою карткою Card або Column НЕ повинно бути слова const
                color: Colors.purple.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🗓️ Планувальник ІРП за днями', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.purple)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text('Тривалість плану: ', style: TextStyle(fontSize: 13)),
                          DropdownButton<int>(
                            // Захист: якщо irp або plannedDays дорівнює null, ставимо дефолт 3
                            value: irp.plannedDays ?? 3, 
                            dropdownColor: Colors.purple.shade50,
                            items: [3, 5, 7, 10, 14].map((int value) {
                              return DropdownMenuItem<int>(
                                value: value, 
                                child: Text('$value днів'),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  irp.plannedDays = val;
                                });
                                widget.onUpdate();
                              }
                            },
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white),
                            onPressed: () {
                              try {
                                _generateSmartIrpSchedule();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Помилка генерації баз вправ: $e')),
                                );
                              }
                            },
                            icon: const Icon(Icons.auto_awesome, size: 16),
                            label: const Text('Згенерувати вправи', style: TextStyle(fontSize: 11)),
                          )
                        ],
                      ),
                      
                      if (irp.daysSchedule != null && irp.daysSchedule.isNotEmpty)
                        ...irp.daysSchedule.entries.map((dayEntry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: ExpansionTile(
                              iconColor: Colors.purple,
                              title: Text('День ${dayEntry.key} — Комплекс втручань', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.purple)),
                              children: dayEntry.value.map<Widget>((customEx) {
                                return ListTile(
                                  dense: true,
                                  leading: const Icon(Icons.check_circle_outline, color: Colors.green),
                                  title: Text(customEx.title ?? 'Вправа', style: const TextStyle(fontWeight: FontWeight.w500)),
                                  subtitle: Text('Дозування: ${customEx.dosage ?? ''}'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.edit_road, size: 18, color: Colors.grey),
                                    tooltip: 'Змінити дозування вручну',
                                    onPressed: () => _editTextField('Дозування вправи', customEx.dosage ?? '', (val) {
                                      setState(() {
                                        customEx.dosage = val;
                                        customEx.isCustomized = true;
                                      });
                                      widget.onUpdate();
                                    }),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }).toList()
                      else
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('План порожній. Оберіть кількість днів та натисніть "Згенерувати вправи".', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        )
                    ],
                  ),
                ),
              ),
            ),

            // ==========================================
            // БЛОК 5. ЖУРНАЛ ВІЗИТІВ ТА ПРОВЕДЕННЯ ТЕСТУВАНЬ
            // ==========================================
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(child: Text('🗒️ Фіксація візитів:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                        onPressed: _createNewVisit,
                        icon: const Icon(Icons.add),
                        label: const Text('Додати візит', style: TextStyle(fontSize: 12)),
                      )
                    ],
                  ),
                  
                  if (widget.patient.visits == null || widget.patient.visits.isEmpty)
                    const Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text('Журнал візитів порожній.', style: TextStyle(color: Colors.grey))))
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.patient.visits.length,
                      itemBuilder: (context, vIndex) {
                        final visit = widget.patient.visits[vIndex];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          color: Colors.grey.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Візит від ${visit.date.day.toString().padLeft(2, '0')}.${visit.date.month.toString().padLeft(2, '0')}.${visit.date.year} о ${visit.date.hour.toString().padLeft(2, '0')}:${visit.date.minute.toString().padLeft(2, '0')}', 
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  initialValue: visit.therapeuticNote,
                                  decoration: const InputDecoration(labelText: 'Щоденник візиту', border: OutlineInputBorder()),
                                  maxLines: null,
                                  onChanged: (text) {
                                    visit.therapeuticNote = text;
                                    widget.onUpdate();
                                  },
                                ),
                                const SizedBox(height: 8),
                                if (visit.testResults != null && visit.testResults.isNotEmpty) ...[
                                  const Text('Проведені тестування шкал:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                  ...visit.testResults.entries.map((e) => Text('• ${e.key}: ${e.value}', style: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold))),
                                  const SizedBox(height: 8),
                                ],
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600, foregroundColor: Colors.white),
                                    onPressed: () {
                                      try {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ScalesCatalogScreen(
                                              onScaleTested: (scaleName, result) {
                                                setState(() {
                                                  visit.testResults[scaleName] = result;
                                                  RegExp regExp = RegExp(r'\d+');
                                                  var match = regExp.firstMatch(result);
                                                  double scoreValue = match != null ? double.parse(match.group(0)!) : 50.0;
                                                  
                                                  widget.patient.scaleHistory.add(ScaleHistoryPoint(
                                                    date: DateTime.now(),
                                                    scaleName: scaleName,
                                                    score: scoreValue,
                                                  ));
                                                });
                                                widget.onUpdate();
                                              },
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Екран шкали недоступний або сталася помилка: $e')),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.analytics, size: 16),
                                    label: const Text('Запустити клінічне тестування шкал', style: TextStyle(fontSize: 11)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
            // ==========================================
            // БЛОК 3. SMART ЦІЛІ ТА МКФ (З МОЖЛИВІСТЮ РУЧНОГО КОРЕГУВАННЯ)
            // ==========================================
           Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('🎯 Постановка цілей SMART (МОЗ)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20, color: Colors.indigo), 
                            onPressed: () => _editTextField('Ціль SMART', irp.goalsSmart, (val) => irp.goalsSmart = val),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        irp.goalsSmart.isEmpty ? 'Натисніть олівець, щоб сформулювати ціль...' : irp.goalsSmart, 
                        style: const TextStyle(fontSize: 13),
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('🧬 Коди МКФ:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.indigo)),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20, color: Colors.indigo), 
                            onPressed: () => _editTextField('МКФ коди', irp.mfkCodes, (val) => irp.mfkCodes = val),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        irp.mfkCodes.isEmpty ? 'Натисніть олівець, щоб додати коди МКФ...' : irp.mfkCodes, 
                        style: const TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ==========================================
            // БЛОК 4. АВТОМАТИЧНИЙ КОНСТРУКТОР ІРП НА N ДНІВ
            // ==========================================
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                color: Colors.purple.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🗓️ Планувальник ІРП за днями', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.purple)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text('Тривалість плану: ', style: TextStyle(fontSize: 13)),
                          DropdownButton<int>(
                            value: irp.plannedDays ?? 3, // Безпечний дефолт
                            dropdownColor: Colors.purple.shade50,
                            items: [3, 5, 7, 10, 14].map((int value) {
                              return DropdownMenuItem<int>(
                                value: value, 
                                child: Text('$value днів'),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  irp.plannedDays = val;
                                });
                                widget.onUpdate();
                              }
                            },
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white),
                            onPressed: () {
                              // Безпечний виклик генерації із захистом від падіння екрану
                              try {
                                _generateSmartIrpSchedule();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Помилка генерації баз вправ: $e')),
                                );
                              }
                            },
                            icon: const Icon(Icons.auto_awesome, size: 16),
                            label: const Text('Згенерувати вправи', style: TextStyle(fontSize: 11)),
                          )
                        ],
                      ),
                      
                      // Відображення сітки розбитих по днях вправ
                      if (irp.daysSchedule != null && irp.daysSchedule.isNotEmpty)
                        ...irp.daysSchedule.entries.map((dayEntry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: ExpansionTile(
                              iconColor: Colors.purple,
                              title: Text('День ${dayEntry.key} — Комплекс втручань', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.purple)),
                              children: dayEntry.value.map<Widget>((customEx) {
                                return ListTile(
                                  dense: true,
                                  leading: const Icon(Icons.check_circle_outline, color: Colors.green),
                                  title: Text(customEx.title ?? 'Вправа', style: const TextStyle(fontWeight: FontWeight.w500)),
                                  subtitle: Text('Дозування: ${customEx.dosage ?? ''}'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.edit_road, size: 18, color: Colors.grey),
                                    tooltip: 'Змінити дозування вручну',
                                    onPressed: () => _editTextField('Дозування вправи', customEx.dosage ?? '', (val) {
                                      setState(() {
                                        customEx.dosage = val;
                                        customEx.isCustomized = true;
                                      });
                                      widget.onUpdate();
                                    }),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }).toList()
                      else
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('План порожній. Оберіть кількість днів та натисніть "Згенерувати вправи".', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        )
                    ],
                  ),
                ),
              ),
            ),
            // ==========================================
            // БЛОК 5. ЖУРНАЛ ВІЗИТІВ ТА ПРОВЕДЕННЯ ТЕСТУВАНЬ ЗА ШКАЛАМИ
            // ==========================================
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('🗒️ Фіксація візитів пацієнта:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                    onPressed: _createNewVisit,
                    icon: const Icon(Icons.add),
                    label: const Text('Додати новий візит'),
                  )
                ],
              ),
            ),

            if (patient.visits.isEmpty)
              const Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text('Журнал візитів порожній.', style: TextStyle(color: Colors.grey))))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: patient.visits.length,
                itemBuilder: (context, vIndex) {
                  final visit = patient.visits[vIndex];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    color: Colors.grey.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Візит від ${visit.date.day}.${visit.date.month}.${visit.date.year}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                          const SizedBox(height: 6),
                          TextFormField(
                            initialValue: visit.therapeuticNote,
                            decoration: const InputDecoration(labelText: 'Статус / Текстовий щоденник візиту', border: OutlineInputBorder()),
                            maxLines: null,
                            onChanged: (text) {
                              visit.therapeuticNote = text;
                              widget.onUpdate();
                            },
                          ),
                          const SizedBox(height: 8),
                          
                          if (visit.testResults.isNotEmpty) ...[
                            const Text('Проведені в цей день тестування шкал:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                            ...visit.testResults.entries.map((e) => Text('• ${e.key}: ${e.value}', style: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold))),
                            const SizedBox(height: 8),
                          ],

                          // Кнопка проведення тестування, яка автоматично пише дані в графік
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600, foregroundColor: Colors.white),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ScalesCatalogScreen(
                                      onScaleTested: (scaleName, result) {
                                        setState(() {
                                          visit.testResults[scaleName] = result;
                                          
                                          // Намагаємося витягнути перше числове значення з результату тесту для графіка динаміки
                                          RegExp regExp = RegExp(r'\d+');
                                          var match = regExp.firstMatch(result);
                                          double scoreValue = match != null ? double.parse(match.group(0)!) : 50.0;
                                          
                                          patient.scaleHistory.add(ScaleHistoryPoint(
                                            date: DateTime.now(),
                                            scaleName: scaleName,
                                            score: scoreValue,
                                          ));
                                        });
                                        widget.onUpdate();
                                      },
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.analytics, size: 16),
                              label: const Text('Запустити клінічне тестування шкал'),
                            ),
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
