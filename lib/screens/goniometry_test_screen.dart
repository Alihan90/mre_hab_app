// lib/screens/goniometry_test_screen.dart
import 'package:flutter/material.dart';
import '../models.dart';

class GoniometryInteractiveTestScreen extends StatefulWidget {
  final Function(String, String)? onSaveResult;

  const GoniometryInteractiveTestScreen({Key? key, this.onSaveResult}) : super(key: key);

  @override
  _GoniometryInteractiveTestScreenState createState() => _GoniometryInteractiveTestScreenState();
}

class _GoniometryInteractiveTestScreenState extends State<GoniometryInteractiveTestScreen> {
  final List<JointMovementNorm> _jointsNormative = [
    JointMovementNorm(jointName: "Плечовий суглоб", movementType: "Згинання", normalValue: 180, instruction: "Лежачи на спині, рука вздовж тулуба. Рух прямо вгору."),
    JointMovementNorm(jointName: "Плечовий суглоб", movementType: "Розгинання", normalValue: 60, instruction: "Лежачи на животі. Рух руки назад і вгору."),
    JointMovementNorm(jointName: "Плечовий суглоб", movementType: "Відведення", normalValue: 180, instruction: "Рух руки через сторону вгору."),
    JointMovementNorm(jointName: "Ліктьовий суглоб", movementType: "Згинання", normalValue: 150, instruction: "Пацієнт на спині, плече стабілізоване. Максимальне згинання ліктя."),
    JointMovementNorm(jointName: "Кульшовий суглоб", movementType: "Згинання", normalValue: 120, instruction: "Лежачи на спині. Згинання ноги в кульшовому і колінному суглобах."),
    JointMovementNorm(jointName: "Колінний суглоб", movementType: "Згинання", normalValue: 135, instruction: "Лежачи на животі. Підтягування п'ятки до сідниці."),
  ];

  final Map<int, int> _enteredValues = {};
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.orange.shade50,
            padding: const EdgeInsets.all(12),
            child: Text(
              widget.onSaveResult != null 
                ? "Запис вимірювань активний (дані будуть внесені до карти пацієнта)"
                : "Автономний режим перегляду норм гоніометрії",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange.shade900, fontSize: 13),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _jointsNormative.length,
              itemBuilder: (context, index) {
                final item = _jointsNormative[index];
                final enteredValue = _enteredValues[index];
                bool isDeficit = enteredValue != null && enteredValue < item.normalValue;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // ВИПРАВЛЕНО ТУТ!
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.jointName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                  Text(item.movementType, style: TextStyle(fontSize: 13, color: Colors.orange.shade800, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(6)),
                              child: Text("Норма: ${item.normalValue}°", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(item.instruction, style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text("Кут: ", style: TextStyle(fontWeight: FontWeight.w500)),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 80,
                              height: 38,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8), suffixText: "°"),
                                onChanged: (val) {
                                  setState(() {
                                    _enteredValues[index] = int.tryParse(val) ?? 0;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 15),
                            if (enteredValue != null)
                              Row(
                                children: [
                                  Icon(isDeficit ? Icons.arrow_downward : Icons.check, color: isDeficit ? Colors.red : Colors.green, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    isDeficit ? "Дефіцит: -${item.normalValue - enteredValue}°" : "Норма!",
                                    style: TextStyle(color: isDeficit ? Colors.red : Colors.green, fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: _notesController,
                  decoration: const InputDecoration(labelText: "Клінічний коментар терапевта", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade700, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    onPressed: _enteredValues.isEmpty ? null : () => _saveData(),
                    child: const Text("Зберегти дані гоніометрії", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _saveData() {
    String summary = "";
    _enteredValues.forEach((index, val) {
      final item = _jointsNormative[index];
      summary += "${item.jointName} (${item.movementType}): $val°; ";
    });
    if (_notesController.text.isNotEmpty) {
      summary += " Коментар: ${_notesController.text}";
    }

    if (widget.onSaveResult != null) {
      widget.onSaveResult!("Гоніометрія", summary);
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Збережено"),
        content: const Text("Дані успішно записані до протоколу реабілітації пацієнта."),
        actions: [
          TextButton(onPressed: () { Navigator.pop(ctx); }, child: const Text("ОК"))
        ],
      ),
    );
  }
}
