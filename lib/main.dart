// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/patients_screen.dart';
import 'screens/scales_catalog_screen.dart';
import 'screens/exercises_catalog_view.dart'; // Переконайтеся, що шлях та назва класу збігаються

void main() {
  runApp(const RehabilitationApp());
}

class RehabilitationApp extends StatelessWidget {
  const RehabilitationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MReHab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      // Підтримка української розкладки клавіатури
      supportedLocales: const [
        Locale('uk', 'UA'),
        Locale('en', 'US'),
      ],
      home: const MainDashboardScreen(),
    );
  }
}

// ==========================================
// 1. ГОЛОВНИЙ ЕКРАН — РОБОЧИЙ СТІЛ (6 ПЛИТОК)
// ==========================================
class MainDashboardScreen extends StatelessWidget {
  const MainDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MReHab — Робочий стіл",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              "Оберіть необхідний клінічний інструмент:",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                children: [
                  _buildDashboardCard(
                    context,
                    title: "Пацієнти",
                    subtitle: "База та Журнал карт",
                    icon: Icons.people,
                    color: Colors.blue.shade600,
                    destination: const PatientsScreen(),
                  ),
                  _buildDashboardCard(
                    context,
                    title: "Клінічні шкали",
                    subtitle: "16 тестів та Гоніометрія",
                    icon: Icons.assignment,
                    color: Colors.indigo.shade600,
                    destination: const ScalesCatalogScreen(),
                  ),
                  _buildDashboardCard(
                    context,
                    title: "Конструктор цілей",
                    subtitle: "SMART критерії",
                    icon: Icons.track_changes,
                    color: Colors.green.shade600,
                    destination: const EmbeddedSmartGoalsScreen(),
                  ),
                  _buildDashboardCard(
                    context,
                    title: "МКХ-10 / МКФ",
                    subtitle: "Діагностичні коди",
                    icon: Icons.assignment_turned_in,
                    color: Colors.amber.shade700,
                    destination: const EmbeddedIcdScreen(),
                  ),
                  _buildDashboardCard(
                    context,
                    title: "Вправи та ЛФК",
                    subtitle: "Протоколи занять",
                    icon: Icons.fitness_center,
                    color: Colors.purple.shade600,
                    destination: const ExercisesCatalogView(),
                  ),
                  _buildDashboardCard(
                    context,
                    title: "Налаштування",
                    subtitle: "Профіль терапевта",
                    icon: Icons.settings,
                    color: Colors.teal.shade600,
                    destination: null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget? destination,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          if (destination != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Модуль '$title' налаштовується.")),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, size: 32, color: color),
              ),
              const Spacer(),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, height: 1.2)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade600, height: 1.2)),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. ВБУДОВАНИЙ ЕКРАН КОНСТРУКТОРА ЦІЛЕЙ SMART (ВИПРАВЛЕНО)
// ==========================================
class EmbeddedSmartGoalsScreen extends StatefulWidget {
  const EmbeddedSmartGoalsScreen({Key? key}) : super(key: key);

  @override
  State<EmbeddedSmartGoalsScreen> createState() => _EmbeddedSmartGoalsScreenState();
}

class _EmbeddedSmartGoalsScreenState extends State<EmbeddedSmartGoalsScreen> {
  // Створюємо карту контролерів для збереження введеного тексту
  final Map<String, TextEditingController> _controllers = {
    "S": TextEditingController(),
    "M": TextEditingController(),
    "A": TextEditingController(),
    "R": TextEditingController(),
    "T": TextEditingController(),
  };

  final List<Map<String, String>> _fields = [
    {"key": "S", "t": "S - Специфічна (Specific)", "h": "Яку саме функцію відновлюємо?"},
    {"key": "M", "t": "M - Вимірювана (Measurable)", "h": "В яких одиницях (градуси, метри, бали)?"},
    {"key": "A", "t": "A - Досяжна (Achievable)", "h": "Реалістичність з огляду на травму"},
    {"key": "R", "t": "R - Релевантна (Relevant)", "h": "Важливість для повсякденного життя пацієнта"},
    {"key": "T", "t": "T - Обмежена в часі (Time-bound)", "h": "Термін виконання (напр. 2 тижні)"},
  ];

  @override
  void dispose() {
    // Обов'язково очищуємо пам'ять від контролерів
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Конструктор цілей SMART"),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Постановка цілей реабілітації",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _fields.length,
                itemBuilder: (context, index) {
                  final f = _fields[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: _controllers[f["key"]],
                      decoration: InputDecoration(
                        labelText: f["t"],
                        hintText: f["h"],
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600),
                onPressed: () {
                  // Тут тепер можна зібрати реальний текст
                  String finalGoal = _controllers.values.map((c) => c.text).join(" | ");
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Ціль збережено в протокол пацієнта")),
                  );
                },
                child: const Text("Зберегти ціль", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. ВБУДОВАНИЙ ЕКРАН КЛАСИФІКАТОРА МКХ-10
// ==========================================
class EmbeddedIcdScreen extends StatefulWidget {
  const EmbeddedIcdScreen({Key? key}) : super(key: key);

  @override
  State<EmbeddedIcdScreen> createState() => _EmbeddedIcdScreenState();
}

class _EmbeddedIcdScreenState extends State<EmbeddedIcdScreen> {
  final List<Map<String, String>> _icdCodes = [
    {"code": "M50", "name": "Ураження міжхребцевих дисків шийного відділу"},
    {"code": "G80", "name": "Церебральний параліч (ДЦП)"},
    {"code": "I69", "name": "Наслідки цереброваскулярних хвороб (Інсульт)"},
    {"code": "M16", "name": "Коксартроз (артроз кульшового суглоба)"},
    {"code": "S42", "name": "Перелом плечової кістки / суглоба"},
    {"code": "T90", "name": "Наслідки травм голови"},
  ];

  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filtered = _icdCodes
        .where((e) => e["code"]!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                      e["name"]!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Класифікатор МКХ-10 / МКФ"),
        backgroundColor: Colors.amber.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Пошук коду або діагнозу",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Chip(
                        label: Text(filtered[index]["code"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        backgroundColor: Colors.amber.shade100,
                      ),
                      title: Text(filtered[index]["name"]!),
                      trailing: const Icon(Icons.add_circle_outline, color: Colors.amber),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Код ${filtered[index]["code"]} вибрано")),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
