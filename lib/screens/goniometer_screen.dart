import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:sensors_plus/sensors_plus.dart';

class JointNorm {
  final String jointName;
  final String movementType;
  final String normalRom;
  final String Instructions;

  const JointNorm({
    required this.jointName,
    required this.movementType,
    required this.normalRom,
    required this.Instructions,
  });
}

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
  dynamic _accelerometerSubscription;

  final List<JointNorm> _jointNorms = const [
    JointNorm(
      jointName: 'Плечовий суглоб',
      movementType: 'Згинання (Flexion)',
      normalRom: '0° – 180°',
      Instructions: 'Вісь: латеральна поверхня акроміону. Рухоме плече: по осі плечової кістки до латерального надвиростка.',
    ),
    JointNorm(
      jointName: 'Плечовий суглоб',
      movementType: 'Розгинання (Extension)',
      normalRom: '0° – 60°',
      Instructions: 'Вісь: латеральна поверхня акроміону. Рухоме плече вздовж плечової кістки назад.',
    ),
    JointNorm(
      jointName: 'Плечовий суглоб',
      movementType: 'Відведення (Abduction)',
      normalRom: '0° – 180°',
      Instructions: 'Вісь: задній бік суглоба, centre голівки. Рухоме плече паралельно хребту.',
    ),
    JointNorm(
      jointName: 'Ліктьовий суглоб',
      movementType: 'Згинання / Розгинання',
      normalRom: '0° (розгинання) – 150° (згинання)',
      Instructions: 'Вісь: латеральний надвиросток плеча. Рухоме плече: вздовж променевої кістки до шилоподібного відростка.',
    ),
    JointNorm(
      jointName: 'Передпліччя',
      movementType: 'Пронація / Супінація',
      normalRom: '80° (пронація) / 80° (супінація)',
      Instructions: 'Пацієнт тримає ручку. Вісь: поздовжня вісь через третій палець кисті.',
    ),
    JointNorm(
      jointName: 'Кульшовий суглоб',
      movementType: 'Згинання (пряма нога)',
      normalRom: '0° – 90° (з зігнутим коліном до 120°)',
      Instructions: 'Вісь: великий вертлюг стегнової кістки. Рухоме плече: по лінії стегна до латерального виростка.',
    ),
    JointNorm(
      jointName: 'Кульшовий суглоб',
      movementType: 'Відведення (Abduction)',
      normalRom: '0° – 45°',
      Instructions: 'Вісь: передня верхня клубова ость (SIAS). Рухоме плече спрямоване на колінну чашечку.',
    ),
    JointNorm(
      jointName: 'Колінний суглоб',
      movementType: 'Згинання (Flexion)',
      normalRom: '0° (повне розгинання) – 135°-145°',
      Instructions: 'Вісь: латеральний виросток стегна. Опора: великий вертлюг. Рухоме плече: до латеральної кісточки гомілки.',
    ),
    JointNorm(
      jointName: 'Гомілковостопний суглоб',
      movementType: 'Тильне згинання (Dorsiflexion)',
      normalRom: '0° – 20°',
      Instructions: 'Вісь: латеральна кісточка. Опора: по лінії малої гомілкової кістки. Рухоме плече: паралельно 5-й плесновій кістці.',
    ),
    JointNorm(
      jointName: 'Гомілковостопний суглоб',
      movementType: 'Підошовне згинання (Plantarflexion)',
      normalRom: '0° – 50°',
      Instructions: 'Вісь: латеральна кісточка. Рух стопи вниз від нейтрального положення (90°).',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _accelerometerSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      setState(() {
        double radians = math.atan2(event.x, event.y);
        double degrees = radians * (180 / math.pi);
        if (degrees < 0) {
          degrees = 360 + degrees;
        }
        _currentAngle = double.parse(degrees.toStringAsFixed(1));
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
        title: const Text('Повноцінна Гоніометрія та ROM'),
        backgroundColor: Colors.orange.shade100,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Colors.orange.shade50,
              child: const TabBar(
                labelColor: Colors.orange,
                unselectedLabelColor: Colors.black54,
                indicatorColor: Colors.orange,
                tabs: [
                  Tab(icon: Icon(Icons.screen_rotation), text: 'Вимірювач кута'),
                  Tab(icon: Icon(Icons.menu_book), text: 'Таблиця норм (Суглоби)'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildGoniometerTool(),
                  _buildJointsDirectory(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoniometerTool() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Card(
            color: Colors.orange.shade50,
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Зафіксуйте старт на проксимальному сегменті суглоба, проведіть рух кінцівки та зафіксуйте фініш. Порівняйте отриманий ROM з нормативами у сусідній вкладці.',
                style: TextStyle(fontSize: 12, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Column(
            children: [
              const Text('Поточний нахил:', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: CircularProgressIndicator(
                      value: _currentAngle / 360,
                      strokeWidth: 10,
                      backgroundColor: Colors.grey.shade200,
                      color: Colors.orange,
                    ),
                  ),
                  Text('$_currentAngle°', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(children: [const Text('Старт', style: TextStyle(fontSize: 12)), Text(_startAngle != null ? '$_startAngle°' : '--', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue))]),
                  Container(width: 1, height: 30, color: Colors.grey.shade300),
                  Column(children: [const Text('Финіш', style: TextStyle(fontSize: 12)), Text(_endAngle != null ? '$_endAngle°' : '--', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple))]),
                  Container(width: 1, height: 30, color: Colors.grey.shade300),
                  Column(children: [const Text('Чистий ROM', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), Text('$_calculatedRom°', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green))]),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                      onPressed: () => setState(() => _startAngle = _currentAngle),
                      child: const Text('Кут Старт'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                      onPressed: () => setState(() => _endAngle = _currentAngle),
                      child: const Text('Кут Фініш'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red, minimumSize: const Size(double.infinity, 44), side: const BorderSide(color: Colors.red)),
                onPressed: _resetGoniometer,
                icon: const Icon(Icons.refresh),
                label: const Text('Скинути дані'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildJointsDirectory() {
    return ListView.builder(
      itemCount: _jointNorms.length,
      itemBuilder: (context, index) {
        final norm = _jointNorms[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ExpansionTile(
            leading: const Icon(Icons.accessibility_new, color: Colors.orange),
            title: Text(norm.jointName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            subtitle: Text('${norm.movementType}  |  Норма: ${norm.normalRom}', style: TextStyle(fontSize: 13, color: Colors.orange.shade900, fontWeight: FontWeight.w500)),
            children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Методика укладання гоніометра:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54)),
                    const SizedBox(height: 4),
                    Text(norm.Instructions, style: const TextStyle(fontSize: 13, height: 1.3, color: Colors.black87)),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }
}
