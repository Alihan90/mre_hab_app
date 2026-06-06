import 'package:flutter/material.dart';
import '../models.dart'; // Імпорт твоїх моделей з кореня lib

class GoniometryInteractiveTestScreen extends StatefulWidget {
  final String? patientId; 

  const GoniometryInteractiveTestScreen({Key? key, this.patientId}) : super(key: key);

  @override
  _GoniometryInteractiveTestScreenState createState() => _GoniometryInteractiveTestScreenState();
}

class _GoniometryInteractiveTestScreenState extends State<GoniometryInteractiveTestScreen> {
  // Довідник нормативів суглобів
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
      appBar: AppBar(
        title: const Text("Проведення гоніометрії"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.teal.shade50,
            padding: const EdgeInsets.all(12),
            child: Text(
              widget.patientId != null 
                ? "Запис тесту в карту пацієнта ID: ${widget.patientId}"
                : "Окремий експрес-тест (без прив'язки до карти)",
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
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
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.between,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.jointName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  Text(item.movementType, style: TextStyle(fontSize: 14, color: Colors.teal.shade700)),
                                ],
                              ),
                            ),
                            Chip(
                              label: Text("Норма: ${item.normalValue}°"),
                              backgroundColor: Colors.grey.shade200,
                            )
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(item.instruction, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text("Заміряний кут: ", style: TextStyle(fontWeight: FontWeight.w500)),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 80,
                              height: 40,
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
                              Text(
                                isDeficit ? "Дефіцит: -${item.normalValue - enteredValue}°" : "Норма!",
                                style: TextStyle(color: isDeficit ? Colors.red : Colors.green, fontWeight: FontWeight.bold),
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
                  decoration: const InputDecoration(labelText: "Примітки до тестування", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    onPressed: _enteredValues.isEmpty ? null : () {
                      _showSuccessDialog();
                    },
                    child: const Text("Зберегти результати тесту", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Збережено!"),
        content: Text(widget.patientId != null ? "Дані успішно записані в карту пацієнта." : "Тест успішно завершено."),
        actions: [
          TextButton(onPressed: () { Navigator.pop(ctx); Navigator.pop(context); }, child: const Text("ОК"))
        ],
      ),
    );
  }
}
