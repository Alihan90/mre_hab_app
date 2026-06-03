import 'package:flutter/material.dart';
import '../models.dart';

class IrpGlobalScreen extends StatefulWidget {
  final List<Patient> patients;
  final VoidCallback onUpdate;

  const IrpGlobalScreen({super.key, required this.patients, required this.onUpdate});

  @override
  State<IrpGlobalScreen> createState() => _IrpGlobalScreenState();
}

class _IrpGlobalScreenState extends State<IrpGlobalScreen> {
  Patient? _selectedPatient;
  
  final _goalsController = TextEditingController();
  final _mfkController = TextEditingController();
  final _interventionController = TextEditingController();
  final _specialistController = TextEditingController();
  String _rehabilitationCycle = 'Первинний';

  @override
  void initState() {
    super.initState();
    if (widget.patients.isNotEmpty) {
      _loadPatientData(widget.patients.first);
    }
  }

  void _loadPatientData(Patient patient) {
    _selectedPatient = patient;
    _goalsController.text = patient.irp.goalsSmart;
    _mfkController.text = patient.irp.mfkCodes;
    _interventionController.text = patient.irp.interventionPlan;
    _specialistController.text = patient.irp.specialistName;
    _rehabilitationCycle = patient.irp.rehabilitationCycle;
  }

  void _saveIrpData() {
    if (_selectedPatient != null) {
      setState(() {
        _selectedPatient!.irp.goalsSmart = _goalsController.text.trim();
        _selectedPatient!.irp.mfkCodes = _mfkController.text.trim();
        _selectedPatient!.irp.interventionPlan = _interventionController.text.trim();
        _selectedPatient!.irp.specialistName = _specialistController.text.trim();
        _selectedPatient!.irp.rehabilitationCycle = _rehabilitationCycle;
      });
      
      widget.onUpdate();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ІРП для пацієнта ${_selectedPatient!.name} успішно збережено за протоколом МОЗ!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Конструктор ІРП та МКФ'),
        backgroundColor: Colors.teal.shade200,
      ),
      body: widget.patients.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'У реєстрі немає пацієнтів.\nСпочатку створіть картку пацієнта в розділі "Реєстр".',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              key: const ValueKey('irp_global_layout_scroll'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Виберіть пацієнта для редагування ІРП:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.teal),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<Patient>(
                      value: _selectedPatient,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: widget.patients.map((Patient p) {
                        return DropdownMenuItem<Patient>(
                          value: p,
                          child: Text(p.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        );
                      }).toList(),
                      onChanged: (Patient? newPatient) {
                        if (newPatient != null) {
                          setState(() {
                            _loadPatientData(newPatient);
                          });
                        }
                      },
                    ),
                  ),
                  const Divider(height: 24, thickness: 1),

                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(8)),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Методичні вимоги МОЗ України:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.teal)),
                        SizedBox(height: 4),
                        Text(
                          '• SMART-ціль має містити часові рамки та чіткий критерій оцінки (наприклад, бали за шкалою або метри).\n'
                          '• Коди МКФ вносяться у форматі доменів (напр., b730 — сила м\'язів, d450 — ходьба) з визначенням кваліфікатора порушення від 0 до 4.',
                          style: TextStyle(fontSize: 11, color: Colors.black87, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: _goalsController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: 'Реабілітаційні цілі (S.M.A.R.T. формат)',
                      hintText: 'Наприклад: Збільшити баланс за Бергом до 45 балів та забезпечити самостійне пересаджування до 20.07.2026.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: _mfkController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: 'Функціональний діагноз за МКФ (коди та категорії)',
                      hintText: 'Наприклад: b730.2 помірне порушення сили м\'язів кінцівок, d410.1 легке порушення зміни положення тіла.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Text('Реабілітаційний цикл:', style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _rehabilitationCycle,
                          decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                          items: ['Первинний', 'Повторний', 'Заключний'].map((String cycle) {
                            return DropdownMenuItem(value: cycle, child: Text(cycle));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _rehabilitationCycle = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: _interventionController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: 'План втручань та терапевтичних технік',
                      hintText: 'Наприклад: Вертикалізація 30 хв/день, механотерапія верхньої кінцівки, пропріоцептивне тренування балансу.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: _specialistController,
                    decoration: const InputDecoration(
                      labelText: 'ПІБ Відповідального фізичного терапевта',
                      hintText: 'Наприклад: Петренко В.О.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade700,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _saveIrpData,
                    icon: const Icon(Icons.gavel),
                    label: const Text('Затвердити та зберегти ІРП пацієнта', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _goalsController.dispose();
    _mfkController.dispose();
    _interventionController.dispose();
    _specialistController.dispose();
    super.dispose();
  }
}
