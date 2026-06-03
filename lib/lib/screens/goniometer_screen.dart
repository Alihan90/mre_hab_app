import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:sensors_plus/sensors_plus.dart';

class GoniometerScreen extends StatefulWidget {
  const GoniometerScreen({super.key});

  @override
  State<GoniometerScreen> createState() => _GoniometerScreenState();
}

class _GoniometerScreenState extends State<GoniometerScreen> {
  double _currentAngle = 0.0;
  double? _startAngle;
  double? _endAngle;
  double _calculatedRom = 0.0;
  
  // Змінна для підписки на датчик, щоб вчасно її закрити і не перевантажувати телефон
  dynamic _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    // Підключаємося до датчика нахилу смартфона
    _accelerometerSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      setState(() {
        // Вираховуємо кут нахилу в градусах відносно осі Y та Z
        double radians = math.atan2(event.x, event.y);
        double degrees = radians * (180 / math.pi);
        
        // Переводимо в діапазон від 0 до 360 градусів
        if (degrees < 0) {
          degrees = 360 + degrees;
        }
        _currentAngle = double.parse(degrees.toStringAsFixed(1));
        
        // Якщо зафіксовано обидва кути, вираховуємо амплітуду (ROM)
        _calculateRom();
      });
    });
  }

  void _calculateRom() {
    if (_startAngle != null && _endAngle != null) {
      double diff = (_endAngle! - _startAngle!).abs();
      if (diff > 180) {
        diff = 360 - diff;
      }
      _calculatedRom = double.parse(diff.toStringAsFixed(1));
    }
  }

  void _resetGoniometer() {
    setState(() {
      _startAngle = null;
      _endAngle = null;
      _calculatedRom = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Цифровий Гоніометр (ROM)'),
        backgroundColor: Colors.orange.shade100,
      ),
      body: Column(
        children: [
          // Методична інструкція проведення гоніометрії
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.orange.shade50,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Інструкція з вимірювання амплітуди (ROM)', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  '1. Прикладіть бічну грань телефона до проксимального сегменту суглоба пацієнта.\n'
                  '2. Натисніть "Зафіксувати початковий кут".\n'
                  '3. Виконайте рух у суглобі разом із телефоном до кінцевої точки.\n'
                  '4. Натисніть "Зафіксувати кінцевий кут". Додаток сам порахує чистий кут руху.',
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Візуальний круглий індикатор поточного нахилу
                  Column(
                    children: [
                      const Text('Поточний нахил пристрою:', style: TextStyle(fontSize: 16, color: Colors.grey)),
                      const SizedBox(height: 10),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 160,
                            height: 160,
                            child: CircularProgressIndicator(
                              value: _currentAngle / 360,
                              strokeWidth: 12,
                              backgroundColor: Colors.grey.shade200,
                              color: Colors.orange,
                            ),
                          ),
                          Text(
                            '$_currentAngle°',
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Секція фіксації результатів
                  Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text('Старт', style: TextStyle(fontSize: 14)),
                              const SizedBox(height: 6),
                              Text(
                                _startAngle != null ? '$_startAngle°' : '--',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                              ),
                            ],
                          ),
                          Container(width: 1, height: 40, color: Colors.grey.shade300),
                          Column(
                            children: [
                              const Text('Фініш', style: TextStyle(fontSize: 14)),
                              const SizedBox(height: 6),
                              Text(
                                _endAngle != null ? '$_endAngle°' : '--',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
                              ),
                            ],
                          ),
                          Container(width: 1, height: 40, color: Colors.grey.shade300),
                          Column(
                            children: [
                              const Text('Амплітуда (ROM)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Text(
                                '$_calculatedRom°',
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Кнопки керування процесом
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                setState(() {
                                  _startAngle = _currentAngle;
                                  _calculateRom();
                                });
                              },
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Кут Старт', style: TextStyle(fontSize: 14)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                setState(() {
                                  _endAngle = _currentAngle;
                                  _calculateRom();
                                });
                              },
                              icon: const Icon(Icons.stop),
                              label: const Text('Кут Фініш', style: TextStyle(fontSize: 14)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          minimumSize: const Size(double.infinity, 48),
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _resetGoniometer,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Скинути показники', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Обов'язково відключаємося від датчиків при виході з екрана, щоб додаток не вилітав
    _accelerometerSubscription?.cancel();
    super.dispose();
  }
}
