// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// ==========================================
// СТРУКТУРА ДАНИХ ДЛЯ МЕДИЧНОЇ КАРТИ ПАЦІЄНТА
// ==========================================
class PatientCard {
  final String id;
  final String fullName;
  final String birthDate;
  final String primaryDiagnosis;
  List<String> smartGoals; // База для Кроку 3 (Конструктор SMART)
  List<String> icdCodes;   // База для Кроку 4 (Довідник МКХ-10)

  PatientCard({
    required this.id,
    required this.fullName,
    required this.birthDate,
    required this.primaryDiagnosis,
    this.smartGoals = const [],
    this.icdCodes = const [],
  });
}

// ==========================================
// ЗАГЛУШКИ ДЛЯ ІНШИХ МОДУЛІВ (БУДУТЬ НАПОВНЮВАТИСЬ ДАЛІ)
// ==========================================
class ScalesCatalogScreen extends StatelessWidget {
  const ScalesCatalogScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Клінічні шкали")));
}

class ExercisesCatalogView extends StatelessWidget {
  const ExercisesCatalogView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Вправи та ЛФК")));
}

// Головна точка входу
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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
class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({Key? key}) : super(key: key);

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  // Централізована база даних пацієнтів у пам'яті (State)
  final List<PatientCard> _globalPatients = [
    PatientCard(
      id: "1",
      fullName: "Іваненко Петро Миколайович",
      birthDate: "15.05.1978",
      primaryDiagnosis: "Наслідки ішемічного інсульту, лівобічний геміпарез",
      smartGoals: ["Збільшити кут згинання у ліктьовому суглобі до 90° за 3 тижні"],
      icdCodes: ["I69.3"],
    ),
    PatientCard(
      id: "2",
      fullName: "Сидоренко Ольга Володимирівна",
      birthDate: "22.11.1990",
      primaryDiagnosis: "Компресійний перелом L1 хребця, стан після металоостеосинтезу",
      smartGoals: ["Ходьба без опори на відстань до 100м без болю за 14 днів"],
      icdCodes: ["S32.0"],
    ),
  ];

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
                    destination: PatientsScreen(
                      patients: _globalPatients,
                      onPatientsUpdated: () => setState(() {}),
                    ),
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
              const SnackBar(content: Text("Модуль налаштовується")),
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
// 🛠️ РЕАЛІЗАЦІЯ КРОКУ 1: ЕКРАН БАЗИ ПАЦІЄНТІВ
// ==========================================
class PatientsScreen extends StatefulWidget {
  final List<PatientCard> patients;
  final VoidCallback onPatientsUpdated;

  const PatientsScreen({
    Key? key,
    required this.patients,
    required this.onPatientsUpdated,
  }) : super(key: key);

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  String _searchQuery = "";

  void _showAddPatientDialog() {
    final nameController = TextEditingController();
    final dateController = TextEditingController();
    final diagnosisController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Нова карта пацієнта", style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "ПІБ Пацієнта", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: "Дата народження (ДД.ММ.РРРР)", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: diagnosisController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: "Первинний діагноз", border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Скасувати")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700),
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  widget.patients.add(PatientCard(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    fullName: nameController.text,
                    birthDate: dateController.text.isEmpty ? "Не вказано" : dateController.text,
                    primaryDiagnosis: diagnosisController.text.isEmpty ? "Діагноз відсутній" : diagnosisController.text,
                    smartGoals: [],
                    icdCodes: [],
                  ));
                });
                widget.onPatientsUpdated();
                Navigator.pop(context);
              }
            },
            child: const Text("Створити карту", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _openPatientJournal(PatientCard patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Медична карта пацієнта"),
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Card(
                  color: Colors.blue.shade50,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(patient.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                        const SizedBox(height: 5),
                        Text("Дата народження: ${patient.birthDate}", style: const TextStyle(fontSize: 14)),
                        const Divider(),
                        const Text("Клінічний діагноз:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(patient.primaryDiagnosis, style: TextStyle(color: Colors.grey.shade800)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text("📌 Реабілітаційні цілі (SMART)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                patient.smartGoals.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Цілі ще не встановлено. Скористайтеся Конструктором SMART на робочому столі."),
                      )
                    : Column(
                        children: patient.smartGoals.map((goal) => Card(
                          child: ListTile(
                            leading: const Icon(Icons.track_changes, color: Colors.green),
                            title: Text(goal),
                          ),
                        )).toList(),
                      ),
                const SizedBox(height: 20),
                const Text("🗂️ Зареєстровані коди МКХ-10", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                patient.icdCodes.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Коди не додано. Використовуйте довідник МКХ на робочому столі."),
                      )
                    : Wrap(
                        spacing: 8,
                        children: patient.icdCodes.map((code) => Chip(
                          label: Text(code, style: const TextStyle(fontWeight: FontWeight.bold)),
                          backgroundColor: Colors.amber.shade100,
                          avatar: const Icon(Icons.label, size: 16, color: Colors.amber),
                        )).toList(),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredPatients = widget.patients
        .where((p) => p.fullName.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Реєстр пацієнтів"),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Пошук пацієнта за ПІБ",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filteredPatients.isEmpty
                  ? const Center(child: Text("Пацієнтів не знайдено"))
                  : ListView.builder(
                      itemCount: filteredPatients.length,
                      itemBuilder: (context, index) {
                        final patient = filteredPatients[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: Icon(Icons.person, color: Colors.blue.shade700),
                            ),
                            title: Text(patient.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text("Діагноз: ${patient.primaryDiagnosis}", maxLines: 1, overflow: TextOverflow.ellipsis),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () => _openPatientJournal(patient),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPatientDialog,
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }
}

// ==========================================
// 2. ВБУДОВАНИЙ ЕКРАН КОНСТРУКТОРА ЦІЛЕЙ SMART
// ==========================================
class EmbeddedSmartGoalsScreen extends StatefulWidget {
  const EmbeddedSmartGoalsScreen({Key? key}) : super(key: key);

  @override
  State<EmbeddedSmartGoalsScreen> createState() => _EmbeddedSmartGoalsScreenState();
}

class _EmbeddedSmartGoalsScreenState extends State<EmbeddedSmartGoalsScreen> {
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
                  String finalGoal = _controllers.values.map((c) => c.text).where((text) => text.isNotEmpty).join(" | ");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(finalGoal.isNotEmpty ? "Ціль збережено!" : "Заповніть хоча б одне поле")),
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
