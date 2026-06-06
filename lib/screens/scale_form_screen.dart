// lib/screens/scale_form_screen.dart
import 'package:flutter/material.dart';

class ScaleFormScreen extends StatefulWidget {
  final String scaleId;
  final String scaleName;
  final Function(String, String)? onSave;

  const ScaleFormScreen({
    Key? key,
    required this.scaleId,
    required this.scaleName,
    this.onSave,
  }) : super(key: key);

  @override
  State<ScaleFormScreen> createState() => _ScaleFormScreenState();
}

class _ScaleFormScreenState extends State<ScaleFormScreen> {
  // Змінні стану для BBS
  int _bbsScore = 0;
  
  // Змінні стану для MAS
  String _selectedMasGrade = "0";
  final Map<String, String> _masGrades = {
    "0": "Тонус не підвищений (Норма)",
    "1": "Незначне підвищення (Легкий опір наприкінці пасивного руху)",
    "1+": "Незначне підвищення (Легкий опір протягом менше ніж половини амплітуди рухів)",
    "2": "Помірне підвищення тонусу протягом усього руху, але кінцівка згинається легко",
    "3": "Значне підвищення тонусу, виконання пасивних рухів утруднене",
    "4": "Уражена часть заклякла (Рігідність) у положенні згинання чи розгинання"
  };

  // Текстові контроллери
  final TextEditingController _genericResultController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _genericResultController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.scaleName),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Оцінка стану пацієнта",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
            ),
            const SizedBox(height: 15),
            
            // Динамічний вибір контенту залежно від шкали
            _buildFormContent(),
            
            const SizedBox(height: 20),
            const Text("Додаткові нотатки терапевта:", style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Особливості виконання, скарги пацієнта або умови проведення тесту...",
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _handleSave,
                child: const Text("Зберегти в журнал реабілітації", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    // 1. Форма для Шкали Балансу Берга (BBS)
    if (widget.scaleId == "BBS") {
      String interpretation = "Високий ризик падінь (Пересування у кріслі-колісному)";
      Color alertColor = Colors.red.shade700;
      if (_bbsScore > 20 && _bbsScore <= 40) {
        interpretation = "Середній ризик (Пересування з підтримкою / ходунками)";
        alertColor = Colors.orange.shade800;
      }
      if (_bbsScore > 40) {
        interpretation = "Низький ризик падінь (Самостійна безпечна ходьба)";
        alertColor = Colors.green.shade700;
      }

      return Card(
        color: Colors.blue.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Сумарний бал за всіма 14 руховими тестами:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // ВИПРАВЛЕНО ТУТ
                children: [
                  Text("Бал: $_bbsScore", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const Text("Макс: 56", style: TextStyle(color: Colors.grey)),
                ],
              ),
              Slider(
                value: _bbsScore.toDouble(),
                min: 0,
                max: 56,
                divisions: 56,
                label: "$_bbsScore",
                activeColor: Colors.blue.shade700,
                onChanged: (val) {
                  setState(() => _bbsScore = val.toInt());
                },
              ),
              const Divider(),
              const SizedBox(height: 5),
              Text("Клінічний статус:", style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
              const SizedBox(height: 4),
              Text(interpretation, style: TextStyle(color: alertColor, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ),
      );
    }

    // 2. Форма для Модифікованої шкали Ашворта (MAS)
    if (widget.scaleId == "MAS") {
      return Card(
        color: Colors.orange.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Оберіть виявлений бал м'язового тонусу:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedMasGrade,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(), 
                  filled: true,          // ВИПРАВЛЕНО ТУТ
                  fillColor: Colors.white // ВИПРАВЛЕНО ТУТ
                ),
                items: _masGrades.keys.map((String key) {
                  return DropdownMenuItem<String>(value: key, child: Text("Рівень спастичності: $key"));
                }).toList(),
                onChanged: (val) {
                  setState(() => _selectedMasGrade = val!);
                },
              ),
              const SizedBox(height: 14),
              Text("Клінічний опис прояву:", style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
              const SizedBox(height: 4),
              Text(
                _masGrades[_selectedMasGrade]!,
                style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    // 3. Універсальна форма для решти шкал
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Внесення результату для ${widget.scaleName}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Дана шкала зараз працює в режимі прямої фіксації висновку. Введіть набрані бали або клінічний рівень дитини/дорослого пацієнта.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _genericResultController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Результат оцінки (бали, рівень або стадія)",
                hintText: "Наприклад: Рівень ІІ за класифікацією, або 42 бали",
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSave() {
    String finalResult = "";

    if (widget.scaleId == "BBS") {
      finalResult = "Результат: $_bbsScore/56 балів.";
    } else if (widget.scaleId == "MAS") {
      finalResult = "Ступінь спастичності: Бал $_selectedMasGrade. (${_masGrades[_selectedMasGrade]})";
    } else {
      if (_genericResultController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Будь ласка, введіть результат тестування.")),
        );
        return;
      }
      finalResult = "Результат тестування: ${_genericResultController.text}";
    }

    if (_notesController.text.isNotEmpty) {
      finalResult += " Нотатки: ${_notesController.text}";
    }

    if (widget.onSave != null) {
      widget.onSave!(widget.scaleName, finalResult);
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text("Дані збережено"),
          ],
        ),
        content: Text("Оцінка за шкалою '${widget.scaleName}' успішно записана в журнал клінічних метрик."),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); 
              Navigator.pop(context); 
            },
            child: const Text("Чудово"),
          )
        ],
      ),
    );
  }
}
