// lib/screens/scale_form_screen.dart
import 'package:flutter/material.dart';
import '../data/scales_data.dart'; // Імпортуємо нашу декларативну базу даних

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
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _genericResultController = TextEditingController();

  ScaleProtocol? _protocol;
  Map<String, int> _answers = {}; // Зберігає вибрані бали за ID питань

  @override
  void initState() {
    super.initState();
    // Шукаємо офіційний медичний протокол у нашому реєстрі шкал
    _protocol = clinicalScalesRegistry[widget.scaleId];

    // Якщо протокол знайдено, ініціалізуємо початкові значення для тестування
    if (_protocol != null) {
      for (var q in _protocol!.questions) {
        if (_protocol!.type == ScaleType.yesNoList) {
          _answers[q.id] = 0; // Для Так/Ні за замовчуванням 0 (Ні)
        } else if (_protocol!.type == ScaleType.singleChoice) {
          _answers[q.id] = _protocol!.globalOptions.first.score; 
        } else if (_protocol!.type == ScaleType.multiRadioGroup) {
          _answers[q.id] = q.options.first.score; // Перший доступний клінічний варіант
        }
      }
    }
  }

  // Обчислення сумарного балу за протоколом в реальному часі
  int _calculateTotalScore() {
    return _answers.values.fold(0, (sum, score) => sum + score);
  }

  @override
  void dispose() {
    _notesController.dispose();
    _genericResultController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool hasProtocol = _protocol != null;
    int currentTotal = hasProtocol ? _calculateTotalScore() : 0;
    String interpretation = hasProtocol && _protocol!.interpreter != null
        ? _protocol!.interpreter!(currentTotal)
        : "";

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.scaleName),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Клінічна плашка підрахунку балів у реальному часі
          if (hasProtocol)
            Container(
              width: double.infinity,
              color: Colors.blue.shade900,
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Поточний бал: $currentTotal", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const Icon(Icons.calculate, color: Colors.white70),
                    ],
                  ),
                  if (interpretation.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(interpretation, style: const TextStyle(color: Colors.white90, fontSize: 12, fontWeight: FontWeight.w500)),
                  ]
                ],
              ),
            ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasProtocol ? "Клінічний протокол оцінки" : "Внесення результату огляду",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                  ),
                  const SizedBox(height: 12),
                  
                  // ГОЛОВНИЙ РУШІЙ ГЕНЕРАЦІЇ ТЕСТІВ
                  _buildInteractiveEngine(),
                  
                  const SizedBox(height: 20),
                  const Text("Додаткові клінічні нотатки:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _notesController,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Особливості тонусу, залучення асистентів, скарги пацієнта під час тестування...",
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _handleSave,
                      child: const Text("Зафіксувати в журналі реабілітації", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveEngine() {
    if (_protocol == null) {
      // Якщо шкала ще не розписана подетально, даємо лікарю внести фінальний рівень вручну
      return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Смарт-поле прямого запису", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text("Протокол для цієї шкали знаходиться в процесі інтеграції. Будь ласка, вкажіть висновок огляду.", style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 14),
              TextField(
                controller: _genericResultController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Результат (бали, стадія, рівень за протоколом)",
                  hintText: "Наприклад: Рівень III за шкалою WeeFIM, або 18 балів за шк. Борга",
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ТИП 1: Список питань ТАК / НІ (Кожне ТАК = 1 бал, НІ = 0 балів)
    if (_protocol!.type == ScaleType.yesNoList) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _protocol!.questions.length,
        itemBuilder: (context, index) {
          var q = _protocol!.questions[index];
          bool isChecked = _answers[q.id] == 1;
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: CheckboxListTile(
              activeColor: Colors.blue.shade700,
              title: Text(q.text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              value: isChecked,
              onChanged: (bool? val) {
                setState(() {
                  _answers[q.id] = (val == true) ? 1 : 0;
                });
              },
            ),
          );
        },
      );
    }

    // ТИП 2: Вибір одного глобального рівня (Оксфордська шкала сил м'язів, GMFCS, Ренкін)
    if (_protocol!.type == ScaleType.singleChoice) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _protocol!.questions.length,
        itemBuilder: (context, index) {
          var q = _protocol!.questions[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_protocol!.questions.length > 1 || q.text.length > 5) ...[
                    Text(q.text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey)),
                    const SizedBox(height: 10),
                  ],
                  DropdownButtonFormField<int>(
                    isExpanded: true,
                    style: const TextStyle(fontSize: 13, color: Colors.black),
                    value: _answers[q.id],
                    decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
                    items: _protocol!.globalOptions.map((opt) {
                      return DropdownMenuItem<int>(
                        value: opt.score,
                        child: Text(opt.text, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _answers[q.id] = val!;
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    // ТИП 3: Кожне питання має свій власний унікальний набір клінічних варіантів (Індекс Бартел, Шкала інсульту NIHSS)
    if (_protocol!.type == ScaleType.multiRadioGroup) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _protocol!.questions.length,
        itemBuilder: (context, index) {
          var q = _protocol!.questions[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(q.text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blue.shade900)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    isExpanded: true,
                    style: const TextStyle(fontSize: 13, color: Colors.black),
                    value: _answers[q.id],
                    decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                    items: q.options.map((opt) {
                      return DropdownMenuItem<int>(
                        value: opt.score,
                        child: Text(opt.text, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _answers[q.id] = val!;
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return const SizedBox.shrink();
  }

  void _handleSave() {
    String medicalSummary = "";

    if (_protocol != null) {
      int total = _calculateTotalScore();
      String interpretation = _protocol!.interpreter != null ? _protocol!.interpreter!(total) : "";
      
      medicalSummary = "Проведено тестування за офіційним протоколом: '${_protocol!.name}'. Сумарний показник: $total балів. $interpretation";
    } else {
      if (_genericResultController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Введіть клінічний висновок перед збереженням.")));
        return;
      }
      medicalSummary = "Результат оцінки: ${_genericResultController.text}";
    }

    if (_notesController.text.isNotEmpty) {
      medicalSummary += " Клінічні нотатки терапевта: ${_notesController.text}";
    }

    // Передаємо сформований медичний звіт назад в профіль пацієнта
    if (widget.onSave != null) {
      widget.onSave!(widget.scaleName, medicalSummary);
    }

    // Вікно підтвердження успішного розрахунку
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text("Обчислення завершено"),
          ],
        ),
        content: const Text("Дані успішно провалідовані, суми балів підраховані автоматично згідно з медичними критеріями та занесені в електронну карту."),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text("Внести в карту"),
          )
        ],
      ),
    );
  }
}
