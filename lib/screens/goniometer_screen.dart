// lib/screens/goniometry_test_screen.dart
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:math' as math;
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
  final Map<int, TextEditingController> _controllers = {};
  final TextEditingController _notesController = TextEditingController();

  // Стан для живого гоніометра телефоном
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  int _currentDeviceAngle = 0;
  int? _activeMeasuringIndex; // Індекс суглоба, який зараз міряється телефоном

  @override
  void initState() {
    super.initState();
    // Ініціалізуємо контролери для текстових полів, щоб міняти текст при вимірюванні телефоном
    for (int i = 0; i < _jointsNormative.length; i++) {
      _controllers[i] = TextEditingController();
    }
    _startListeningSensors();
  }

  void _startListeningSensors() {
    _accelerometerSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      if (_activeMeasuringIndex != null) {
        // Обчислюємо кут нахилу смартфона в градусах відносно осі Y та Z
        double radians = math.atan2(event.x, event.y);
        int angle = (radians * 180 / math.pi).round().abs();
        setState(() {
          _currentDeviceAngle = angle;
        });
      }
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _notesController.dispose();
    _controllers.forEach((_, c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Додаємо Scaffold, щоб у екрана з'явилася кнопка "Назад" та верхнє меню, якщо він відкривається окремо!
    return Scaffold(
      appBar: AppBar(
        title: const Text("Вимірювання та Гоніометрія"),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.orange.shade50,
            padding: const EdgeInsets.all(12),
            child: Text(
              widget.onSaveResult != null 
                ? "Запис у карту пацієнта активний. Використовуйте ручне введення або датчики телефону."
                : "Автономний режим: вимірювання кутів та перегляд анатомічних норм.",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange.shade900, fontSize: 12),
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
                bool isCurrentlyMeasuring = _activeMeasuringIndex == index;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        const SizedBox(height: 12),
                        
                        // Зона живого гоніометра, якщо увімкнено вимірювання цим суглобом
                        if (isCurrentlyMeasuring)
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.screen_rotation, color: Colors.orange),
                                    const SizedBox(width: 8),
                                    Text("Кут телефону: $_currentDeviceAngle°", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  ],
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade800),
                                  onPressed: () {
                                    setState(() {
                                      _enteredValues[index] = _currentDeviceAngle;
                                      _controllers[index]!.text = _currentDeviceAngle.toString();
                                      _activeMeasuringIndex = null; // Закриваємо режим вимірювання
                                    });
                                  },
                                  child: const Text("Зафіксувати кут", style: TextStyle(color: Colors.white)),
                                )
                              ],
                            ),
                          ),

                        Row(
                          children: [
                            const Text("Кут: ", style: TextStyle(fontWeight: FontWeight.w500)),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 80,
                              height: 38,
                              child: TextField(
                                controller: _controllers[index],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8), suffixText: "°"),
                                onChanged: (val) {
                                  setState(() {
                                    _enteredValues[index] = int.tryParse(val) ?? 0;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Кнопка активації вбудованого датчика
                            IconButton(
                              icon: Icon(isCurrentlyMeasuring ? Icons.cancel : Icons.add_to_home_screen, color: Colors.blue.shade700),
                              tooltip: "Виміряти нахилом телефону",
                              onPressed: () {
                                setState(() {
                                  if (isCurrentlyMeasuring) {
                                    _activeMeasuringIndex = null;
                                  } else {
                                    _activeMeasuringIndex = index;
                                  }
                                });
                              },
                            ),
                            const Spacer(),
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
                  decoration: const InputDecoration(labelText: "Загальний клінічний коментар терапевта", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade700, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    onPressed: _enteredValues.isEmpty ? null : () => _saveData(),
                    child: const Text("Зберегти результати вимірювань", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      summary += "Коментар: ${_notesController.text}";
    }

    if (widget.onSaveResult != null) {
      widget.onSaveResult!("Гоніометрія за суглобами", summary);
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Дані збережено"),
        content: const Text("Результати апаратного вимірювання зафіксовані в журналі фізичного терапевта."),
        actions: [
          TextButton(onPressed: () { Navigator.pop(ctx); Navigator.pop(context); }, child: const Text("ОК"))
        ],
      ),
    );
  }
}
