// lib/main.dart
import 'dart:convert'; // Потрібно для роботи з JSON
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Наше нове сховище

// ==========================================
// СТРУКТУРА ДАНИХ ДЛЯ МЕДИЧНОЇ КАРТИ ПАЦІЄНТА
// ==========================================
class PatientCard {
  final String id;
  final String fullName;
  final String birthDate;
  final String primaryDiagnosis;
  List<String> smartGoals; 
  List<String> icdCodes;   
  List<String> assignedExercises;

  PatientCard({
    required this.id,
    required this.fullName,
    required this.birthDate,
    required this.primaryDiagnosis,
    required this.smartGoals,
    required this.icdCodes,
    required this.assignedExercises,
  });

  // Перетворюємо об'єкт пацієнта в Map (карту), щоб зберегти в JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'birthDate': birthDate,
      'primaryDiagnosis': primaryDiagnosis,
      'smartGoals': smartGoals,
      'icdCodes': icdCodes,
      'assignedExercises': assignedExercises,
    };
  }

  // Створюємо об'єкт пацієнта з Map, який прочитали з JSON
  factory PatientCard.fromMap(Map<String, dynamic> map) {
    return PatientCard(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      birthDate: map['birthDate'] ?? '',
      primaryDiagnosis: map['primaryDiagnosis'] ?? '',
      smartGoals: List<String>.from(map['smartGoals'] ?? []),
      icdCodes: List<String>.from(map['icdCodes'] ?? []),
      assignedExercises: List<String>.from(map['assignedExercises'] ?? []),
    );
  }
}

// ==========================================
// СТРУКТУРА ДАНИХ ДЛЯ КЛІНІЧНИХ ШКАЛ
// ==========================================
class ClinicalScale {
  final String name;
  final String category;
  final String description;
  final String instruction;
  final String interpretation;

  ClinicalScale({
    required this.name,
    required this.category,
    required this.description,
    required this.instruction,
    required this.interpretation,
  });
}

// ==========================================
// ГОЛОВНА ТОЧКА ВХОДУ В ДОДАТОК
// ==========================================
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
// 1. РОБОЧИЙ СТІЛ (ГОЛОВНЕ МЕНЮ)
// ==========================================
class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({Key? key}) : super(key: key);

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  // Список пацієнтів (початково порожній, дані завантажаться з пам'яті)
  List<PatientCard> _globalPatients = [];
  bool _isLoading = true; // Прапорець завантаження

  @override
  void initState() {
    super.initState();
    _loadPatientsFromStorage(); // Завантажуємо при старті
  }

  // ФУНКЦІЯ ЗАВАНТАЖЕННЯ ДАНИХ ІЗ ПАМ'ЯТІ ТЕЛЕФОНУ
  Future<void> _loadPatientsFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? patientsJson = prefs.getString('saved_patients');

      if (patientsJson != null && patientsJson.isNotEmpty) {
        final List<dynamic> decodedList = jsonDecode(patientsJson);
        setState(() {
          _globalPatients = decodedList.map((item) => PatientCard.fromMap(item)).toList();
          _isLoading = false;
        });
      } else {
        // Якщо додаток запущено вперше і пам'ять порожня — створюємо демо-пацієнтів
        setState(() {
          _globalPatients = [
            PatientCard(
              id: "1",
              fullName: "Іваненко Петро Миколайович",
              birthDate: "15.05.1978",
              primaryDiagnosis: "Наслідки ішемічного інсульту, лівобічний геміпарез",
              smartGoals: ["Ціль: Збільшити кут згинання у ліктьовому суглобі (до 90°). Термін: за 3 тижні."],
              icdCodes: ["I69.3"],
              assignedExercises: ["Дзеркальна терапія для кисті (15 хвилин, 2 рази на день.)"],
            ),
            PatientCard(
              id: "2",
              fullName: "Сидоренко Ольга Володимирівна",
              birthDate: "22.11.1990",
              primaryDiagnosis: "Компресійний перелом L1 хребця, стан після металоостеосинтезу",
              smartGoals: ["Ціль: Ходьба без опори на відстань до 100м. Термін: за 14 днів."],
              icdCodes: ["S32.0"],
              assignedExercises: [],
            ),
          ];
          _isLoading = false;
        });
        _savePatientsToStorage(); // Одразу запишемо їх у базу
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // ФУНКЦІЯ ЗБЕРЕЖЕННЯ ДАНИХ У ПАМ'ЯТЬ ТЕЛЕФОНУ
  Future<void> _savePatientsToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> mappedList = _globalPatients.map((p) => p.toMap()).toList();
    final String encodedData = jsonEncode(mappedList);
    await prefs.setString('saved_patients', encodedData);
  }

  // Метод, який ми викликаємо щоразу, коли щось міняється
  void _handleDataChange() {
    setState(() {});
    _savePatientsToStorage(); // Авто-збереження при будь-якій зміні
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()), // Показуємо індикатор, поки вантажаться дані
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("MReHab — Робочий стіл", style: TextStyle(fontWeight: FontWeight.bold)),
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
                      onPatientsUpdated: _handleDataChange,
                    ),
                  ),
                  _buildDashboardCard(
                    context,
                    title: "Клінічні шкали",
                    subtitle: "20 тестів та Гоніометрія",
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
                    destination: EmbeddedSmartGoalsScreen(
                      patients: _globalPatients,
                      onGoalSaved: _handleDataChange,
                    ),
                  ),
                  _buildDashboardCard(
                    context,
                    title: "МКХ-10 / МКФ",
                    subtitle: "Діагностичні коди",
                    icon: Icons.assignment_turned_in,
                    color: Colors.amber.shade700,
                    destination: EmbeddedIcdScreen(
                      patients: _globalPatients,
                      onIcdAssigned: _handleDataChange,
                    ),
                  ),
                  _buildDashboardCard(
                    context,
                    title: "Вправи та ЛФК",
                    subtitle: "Протоколи занять",
                    icon: Icons.fitness_center,
                    color: Colors.purple.shade600,
                    destination: ExercisesCatalogView(
                      patients: _globalPatients,
                      onExercisesUpdated: _handleDataChange,
                    ),
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
              const SnackBar(content: Text("Модуль налаштування у розробці")),
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
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, height: 1.2)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600, height: 1.2)),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. РЕЄСТР ТА МЕДИЧНІ КАРТКИ ПАЦІЄНТІВ
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
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "ПІБ Пацієнта", border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(controller: dateController, decoration: const InputDecoration(labelText: "Дата народження (ДД.ММ.РРРР)", border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(controller: diagnosisController, maxLines: 2, decoration: const InputDecoration(labelText: "Первинний діагноз", border: OutlineInputBorder())),
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
                    assignedExercises: [],
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

  @override
  Widget build(BuildContext context) {
    final filteredPatients = widget.patients
        .where((p) => p.fullName.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Реєстр пацієнтів"), backgroundColor: Colors.blue.shade700, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Пошук пацієнта за ПІБ", prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
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
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: CircleAvatar(backgroundColor: Colors.blue.shade100, child: Icon(Icons.person, color: Colors.blue.shade700)),
                            title: Text(patient.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: Text("Діагноз: ${patient.primaryDiagnosis}", maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
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

  void _openPatientJournal(PatientCard patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Медична карта"),
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
                    ? const Padding(padding: EdgeInsets.all(8.0), child: Text("Цілі відсутні. Сформуйте їх у Конструкторі SMART."))
                    : Column(
                        children: patient.smartGoals.map((goal) => Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: const Icon(Icons.track_changes, color: Colors.green),
                            title: Text(goal, style: const TextStyle(fontSize: 13)),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18),
                              onPressed: () {
                                setState(() { patient.smartGoals.remove(goal); });
                                widget.onPatientsUpdated();
                              },
                            ),
                          ),
                        )).toList(),
                      ),
                const SizedBox(height: 20),
                const Text("🗂️ Зареєстровані коди МКХ-10", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                patient.icdCodes.isEmpty
                    ? const Padding(padding: EdgeInsets.all(8.0), child: Text("Коди не закріплені. Виберіть коди в модулі МКХ-10."))
                    : Wrap(
                        spacing: 8,
                        children: patient.icdCodes.map((code) => Chip(
                          label: Text(code, style: const TextStyle(fontWeight: FontWeight.bold)),
                          backgroundColor: Colors.amber.shade100,
                          avatar: const Icon(Icons.label, size: 16, color: Colors.amber),
                          onDeleted: () {
                            setState(() { patient.icdCodes.remove(code); });
                            widget.onPatientsUpdated();
                          },
                        )).toList(),
                      ),
                const SizedBox(height: 20),
                const Text("🏋️‍♂️ Призначена програма вправ (ЛФК)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                patient.assignedExercises.isEmpty
                    ? const Padding(padding: EdgeInsets.all(8.0), child: Text("Програма вправ ще не сформована."))
                    : Column(
                        children: patient.assignedExercises.map((ex) => Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          color: Colors.purple.shade50,
                          child: ListTile(
                            leading: const Icon(Icons.fitness_center, color: Colors.purple),
                            title: Text(ex, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18),
                              onPressed: () {
                                setState(() { patient.assignedExercises.remove(ex); });
                                widget.onPatientsUpdated();
                              },
                            ),
                          ),
                        )).toList(),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 3. ПОВНИЙ КАТАЛОГ ШКАЛ ТА ГОНІОМЕТРІЯ
// ==========================================
class ScalesCatalogScreen extends StatefulWidget {
  const ScalesCatalogScreen({Key? key}) : super(key: key);

  @override
  State<ScalesCatalogScreen> createState() => _ScalesCatalogScreenState();
}

class _ScalesCatalogScreenState extends State<ScalesCatalogScreen> {
  String _searchQuery = "";
  String _selectedCategory = "Всі";

  final List<String> _categories = ["Всі", "Неврологія (дорослі)", "Ортопедія та Травматологія", "Кардіо-респіраторна", "Загальнофункциональні", "Pediatria (Дитячі вікові)", "Інструменти"];

  final List<ClinicalScale> _scales = [
    ClinicalScale(
      name: "Модифікована шкала спастичності Ашворт (MAS)",
      category: "Неврологія (дорослі)",
      description: "Оцінка м'язового тонусу та спастичності при дослідженні пасивних рухів кінцівок.",
      instruction: "Проведіть пасивне згинання/розгинання кінцівки у швидкому темпі. Оцініть опір.",
      interpretation: "0: Тонус не підвищений\n1: Легке підвищення (наприкінці руху)\n1+: Легке підвищення (менше половини амплітуди)\n2: Помірне підвищення тонусу, але рух легкий\n3: Значне підвищення тонусу, пасивний рух ускладнений\n4: Уражена частина ригідна",
    ),
    ClinicalScale(
      name: "Шкала інсульту Національного інституту здоров'я (NIHSS)",
      category: "Неврологія (дорослі)",
      description: "Клінічна оцінка тяжкості неврологічного дефіциту у пацієнтів з гострим інсультом.",
      instruction: "Оцініть за чергою 11 параметрів: свідомість, погляд, поля зору, парез обличчя, сила рук/ніг, атаксія, чутливість, мова, дизартрія, ігнорування.",
      interpretation: "0-4 балів: Легкий ступінь інсульту\n5-15 балів: Помірний інсульт\n16-20 балів: Середньо-важкий інсульт\n21-42 балів: Важкий інсульт",
    ),
    ClinicalScale(
      name: "Модифікована шкала Ренкіна (mRS)",
      category: "Неврологія (дорослі)",
      description: "Оцінка ступеня інвалідизазации та загальної незалежності пацієнта після судинних катастроф.",
      instruction: "Шляхом клінічного опитування виявіть уровень обмеження повсякденної життєдіяльності.",
      interpretation: "0: Немає симптомів\n1: Є симптомів, але без обмежень\n2: Легка інвалідність\n3: Помірна інвалідність\n4: Важка інвалідність\n5: Дуже важка (прикутий до ліжка)",
    ),
    ClinicalScale(
      name: "Тест оцінки функції руки Френчай (Frenchay Arm Test)",
      category: "Неврологія (дорослі)",
      description: "Оцінка проксимальної та дистальної рухової функції паретичної верхньої кінцівки.",
      instruction: "Запропонуйте виконати 5 побутових завдань. Кожен успіх — 1 бал.",
      interpretation: "0 балів: Рука повністю нефункциональна\n5 балів: Повна збережена функція руки",
    ),
    ClinicalScale(
      name: "Шкала коми Глазго (GCS)",
      category: "Неврологія (дорослі)",
      description: "Оцінка ступеня пригнічення свідомості та глибини коми.",
      instruction: "Сумуйте бали за трьома тестами: розплющування очей (1-4), мовна реакція (1-5), рухова реакція (1-6).",
      interpretation: "15 балів: Ясна свідомість\n13-14 балів: Оглушення\n9-12 балів: Сопор\n3-8 балів: Кома",
    ),
    ClinicalScale(
      name: "Індекс життєдіяльності Освестрі (ODI)",
      category: "Ортопедія та Травматологія",
      description: "Оцінка впливу больового синдрому в попереку на повсякденне життя.",
      instruction: "Оцініть 10 секцій життєдіяльності від 0 до 5 балів.",
      interpretation: "0-20%: Мінімальне обмеження\n21-40%: Помірне\n41-60%: Важке\n61-80%: Критичне\n81-100%: Повна залежність",
    ),
    ClinicalScale(
      name: "Візуально-аналогова шкала болю (VAS / ЧРШ)",
      category: "Ортопедія та Травматологія",
      description: "Суб'єктивний метод експрес-оцінки інтенсивності болю пацієнтом.",
      instruction: "Запропонуйте пацієнту обрати цифрове значення від 0 до 10.",
      interpretation: "1-3 бали: Слабкий біль\n4-6 балів: Помірний біль\n7-10 балів: Сильний біль",
    ),
    ClinicalScale(
      name: "Мануальне м'язове тестування (MMT за Ловеттом)",
      category: "Ортопедія та Травматологія",
      description: "Оцінка сили та витривалості окремих м'язових груп за 5-бальною системою.",
      instruction: "Протестуйте рух м'яза проти сили тяжіння та проти ручного супротиву терапевта.",
      interpretation: "0: Скорочення немає\n1: Слід скорочення\n2: Рух БЕЗ сили тяжіння\n3: Рух проти сили тяжіння\n4: Рух проти опору\n5: Норма",
    ),
    ClinicalScale(
      name: "Тест 6-хвилинної ходьби (6MWT)",
      category: "Кардіо-респіраторна",
      description: "Оцінка толерантності до фізичних навантажень та кардіореспіраторного статусу.",
      instruction: "Виміряйте максимальну відстань (у метрах), яку пацієнт здатний пройти за 6 хвилин.",
      interpretation: "Результат оцінюється індивідуально за віковими таблицями та у динаміці.",
    ),
    ClinicalScale(
      name: "Борг Шкала Сприйняття Навантаження (RPE Borg Scale)",
      category: "Кардіо-респіраторна",
      description: "Суб'єктивная оцінка фізичного напруження та задишки під час занять ЛФК.",
      instruction: "Пацієнт оцінює свою втому під час навантаження від 6 до 20.",
      interpretation: "6-11: Легке навантаження\n12-14: Помірний рівень (цільова зона кардіо-реабілітації)\n15-18: Важке навантаження\n19-20: Максимум",
    ),
    ClinicalScale(
      name: "Індекс задишки за шкалою MRC (Dyspnea Scale)",
      category: "Кардіо-респіраторна",
      description: "Оцінка ступеня задишки при хронічних легеневих або серцевих патологіях.",
      instruction: "Опитайте пацієнта про побутові умови виникнення відчуття нестачі повітря.",
      interpretation: "Грейд 0: При сильному навантаженні\nГрейд 1: При швидкій ходьбі\nГрейд 2: Ходить повільніше за однолітків\nГрейд 3: Зупиняється після 100 метрів\nГрейд 4: Задишка при одяганні",
    ),
    ClinicalScale(
      name: "Індекс активності повсякденного життя Бартел (Barthel Index)",
      category: "Загальнофункциональні",
      description: "Клінічний стандарт оцінки базової незалежності та самообслуговування пацієнта.",
      instruction: "Оцініть 10 пунктів щоденної активності.",
      interpretation: "0-20 б: Повна залежність\n21-60 б: Тяжка залежність\n61-90 б: Помірна залежність\n91-100 б: Повна функціональна незалежність",
    ),
    ClinicalScale(
      name: "Шкала рівноваги Берга (Berg Balance Scale)",
      category: "Загальнофункциональні",
      description: "Комплексний тест статичної та динамічної рівноваги, визначення ризику падінь.",
      instruction: "Попросіть виконати 14 рухових завдань. Оцінка від 0 до 4 кожне.",
      interpretation: "0-20 балів: Високий ризик падінь\n21-40 балів: Середній ризик падінь\n41-56 балів: Низький ризик",
    ),
    ClinicalScale(
      name: "Індекс мобільності Рівермід (RMI)",
      category: "Загальнофункциональні",
      description: "Скринінгова оцінка рівня мобільності від базових поворотів у ліжку до бігу.",
      instruction: "Оцініть 15 дій дії. За кожне «Так» — 1 бал.",
      interpretation: "0 балів: Повна нерухомість\n15 балів: Максимальна мобільність",
    ),
    ClinicalScale(
      name: "Тест «Встань та йди» (Timed Up and Go - TUG)",
      category: "Загальнофункциональні",
      description: "Швидкий функціональний тест для оцінки динамічного балансу.",
      instruction: "Засічіть час, за який пацієнт встане зі стільця, пройде 3 метри, розвернеться і сяде назад.",
      interpretation: "< 10 сек: Норма\n11-20 сек: Початкові порушення\n> 20 сек: Виражені порушення, високий ризик падінь",
    ),
    ClinicalScale(
      name: "Тест кубиків у коробці (Box and Block Test)",
      category: "Загальнофункциональні",
      description: "Оцінка грубої мануальної спритності та координації рухів.",
      instruction: "Підрахуйте кількість кубиків, перенесених по одному через перегородку за 60 секунд.",
      interpretation: "Показники порівнюють із віковими нормами.",
    ),
    ClinicalScale(
      name: "Функціональні категорії ходьби (FAC)",
      category: "Загальнофункциональні",
      description: "Класифікація рівня незалежності пацієнта під час ходьби.",
      instruction: "Визначте ступінь участі рук терапевта при страховці ходьби пацієнта на 3 метрах.",
      interpretation: "0: Не ходить\n1-2: Потрібна безперервна фізична підтримка\n3: Потрібен лише вербальний нагляд\n4-5: Самостійна ходьба",
    ),
    ClinicalScale(
      name: "Динамічний індекс ходьби (DGI)",
      category: "Загальнофункциональні",
      description: "Дослідження здатності пацієнта адаптувати ходьбу під складні умови.",
      instruction: "Оцініть 8 завдань (зміна темпу, повороти голови, перешкоди, сходи).",
      interpretation: "< 19 балів із 24: Висока ймовірність падінь",
    ),
    ClinicalScale(
      name: "Велика моторна функція (GMFM-88 / GMFM-66)",
      category: "Pediatria (Дитячі вікові)",
      description: "Стандартизований тест кількісної оцінки змін великої моторики у дітей з ДЦП.",
      instruction: "Проведіть тестування за 5 функціональними блоками: від лежання до бігу.",
      interpretation: "Розраховується відсотковий показник виконання завдань.",
    ),
    ClinicalScale(
      name: "Шкала оцінки болю у дітей FLACC",
      category: "Pediatria (Дитячі вікові)",
      description: "Поведінкова шкала оцінки інтенсивності болю у дітей (від 2 міс до 7 років).",
      instruction: "Спостерігайте 1-5 хв. Оцініть обличчя, ноги, активність, крик, втішання від 0 до 2 балів.",
      interpretation: "0 б: Спокій\n1-3 б: Легкий дискомфорт\n4-6 б: Помірний біль\n7-10 б: Сильний біль",
    ),
    ClinicalScale(
      name: "Шкала моторного розвитку немовлят Альберти (AIMS)",
      category: "Pediatria (Дитячі вікові)",
      description: "Оцінка моторного дозрівання малюків від народження до самостійної ходьби (0-18 місяців).",
      instruction: "Спостерігайте за активністю дитини у 4 положеннях: на животі, на спині, сидячи та стоячи.",
      interpretation: "Показник нижче 5-го перцентиля свідчить про затримку розвитку.",
    ),
    ClinicalScale(
      name: "Тест розвитку зорово-моторної інтеграції Ерхардта (EDVA)",
      category: "Pediatria (Дитячі вікові)",
      description: "Оцінка специфічних компонентів рухів рук та зорово-моторної координації у дітей.",
      instruction: "Перевірте мимовільні та довільні реакції: фіксація погляду, простежування, захоплення.",
      interpretation: "Визначається відповідність поточної рухової функції паспортному віку дитини.",
    ),
    ClinicalScale(
      name: "📐 Інструмент: Гоніометрія (Суглобовий статус за ROM)",
      category: "Інструменти",
      description: "Калькулятор дефіциту амплітуди активних та пасивних рухів у суглобах кінцівок.",
      instruction: "Введіть стандартну анатомічну норму для руху та фактичний показник кута.",
      interpretation: "Розрахунок дефіциту кута в градусах та відсотках відхилення від фізіологічної норми.",
    ),
  ];

  void _openScaleDetail(ClinicalScale scale) {
    if (scale.category == "Інструменти") {
      _openGoniometryCalculator();
      return;
    }

    final scoreController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 20, left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Chip(
                label: Text(scale.category, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                backgroundColor: Colors.indigo.shade600,
              ),
              const SizedBox(height: 5),
              Text(scale.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo)),
              const Divider(),
              const Text("📋 Опис:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(scale.description, style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 10),
              const Text("🚀 Методика проведення:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(scale.instruction, style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 10),
              const Text("🔍 Інтерпретація результатів:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
                child: Text(scale.interpretation, style: const TextStyle(fontSize: 12, fontFamily: 'Courier')),
              ),
              const SizedBox(height: 15),
              const Text("🔢 Фіксація балів:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: scoreController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Результат / бали", border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                    onPressed: () {
                      if (scoreController.text.isNotEmpty) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Результат оцінки (${scoreController.text}) зафіксовано")),
                        );
                      }
                    },
                    child: const Text("Оцінити", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  void _openGoniometryCalculator() {
    final normController = TextEditingController();
    final factController = TextEditingController();
    String resultString = "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 20, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("📐 Калькулятор гоніометрії (ROM)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo)),
              const Divider(),
              Row(
                children: [
                  Expanded(child: TextField(controller: normController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Норма (°)", border: OutlineInputBorder()))),
                  const SizedBox(width: 10),
                  Expanded(child: TextField(controller: factController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Кут пацієнта (°)", border: OutlineInputBorder()))),
                ],
              ),
              const SizedBox(height: 15),
              if (resultString.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.red.shade200)),
                  child: Text(resultString, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 13)),
                ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey), onPressed: () => Navigator.pop(context), child: const Text("Закрити", style: TextStyle(color: Colors.white)))),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                      onPressed: () {
                        final double? norm = double.tryParse(normController.text);
                        final double? fact = double.tryParse(factController.text);
                        if (norm != null && fact != null && norm > 0) {
                          final double deficitDeg = norm - fact;
                          final double deficitPct = (deficitDeg / norm) * 100;
                          setModalState(() {
                            resultString = "Дефіциat амплітуди рухів:\n🔻 ${deficitDeg.toStringAsFixed(1)}° (${deficitPct.toStringAsFixed(1)}% від анатомічної норми)";
                          });
                        }
                      },
                      child: const Text("Розрахувати", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredScales = _scales.where((s) {
      final matchesCategory = _selectedCategory == "Всі" || s.category == _selectedCategory;
      final matchesSearch = s.name.toLowerCase().contains(_searchQuery.toLowerCase()) || s.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Клінічні шкали"), backgroundColor: Colors.indigo.shade600, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Пошук шкали чи тесту", prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: ChoiceChip(
                      label: Text(cat, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 11)),
                      selected: isSelected,
                      selectedColor: Colors.indigo.shade600,
                      backgroundColor: Colors.grey.shade200,
                      onSelected: (bool selected) => setState(() => _selectedCategory = cat),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filteredScales.isEmpty
                  ? const Center(child: Text("Тестів не знайдено"))
                  : ListView.builder(
                      itemCount: filteredScales.length,
                      itemBuilder: (context, index) {
                        final scale = filteredScales[index];
                        final isGonio = scale.category == "Інструменти";
                        return Card(
                          elevation: 1,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Icon(isGonio ? Icons.architecture : Icons.assignment_outlined, color: isGonio ? Colors.teal : Colors.indigo.shade400, size: 24),
                            title: Text(scale.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            subtitle: Text(scale.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11)),
                            trailing: const Icon(Icons.play_circle_fill, color: Colors.indigo, size: 24),
                            onTap: () => _openScaleDetail(scale),
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

// ==========================================
// 4. КОНСТРУКТОР SMART-ЦІЛЕЙ
// ==========================================
class EmbeddedSmartGoalsScreen extends StatefulWidget {
  final List<PatientCard> patients;
  final VoidCallback onGoalSaved;

  const EmbeddedSmartGoalsScreen({Key? key, required this.patients, required this.onGoalSaved}) : super(key: key);

  @override
  State<EmbeddedSmartGoalsScreen> createState() => _EmbeddedSmartGoalsScreenState();
}

class _EmbeddedSmartGoalsScreenState extends State<EmbeddedSmartGoalsScreen> {
  PatientCard? _selectedPatient;

  final Map<String, TextEditingController> _controllers = {
    "S": TextEditingController(), "M": TextEditingController(), "A": TextEditingController(), "R": TextEditingController(), "T": TextEditingController(),
  };

  final List<Map<String, String>> _fields = [
    {"key": "S", "t": "S - Специфічна (Specific)", "h": "Яку функцію/дію відновлюємо?"},
    {"key": "M", "t": "M - Вимірювана (Measurable)", "h": "Показник в метрах, градусах або балах"},
    {"key": "A", "t": "A - Досяжна (Achievable)", "h": "Реалістичність мети для пацієнта"},
    {"key": "R", "t": "R - Релевантна (Relevant)", "h": "Важливість цілі для життєдіяльності"},
    {"key": "T", "t": "T - Обмежена в часі (Time-bound)", "h": "Термін досягнення (наприклад: 2 тижні)"},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.patients.isNotEmpty) {
      _selectedPatient = widget.patients.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Конструктор цілей SMART"), backgroundColor: Colors.green.shade600, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Крок 1: Оберіть пацієнта для цілі", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(8), color: Colors.white),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<PatientCard>(
                  value: _selectedPatient,
                  isExpanded: true,
                  hint: const Text("Виберіть карту пацієнта"),
                  items: widget.patients.map((PatientCard p) {
                    return DropdownMenuItem<PatientCard>(value: p, child: Text(p.fullName, style: const TextStyle(fontSize: 14)));
                  }).toList(),
                  onChanged: (PatientCard? val) => setState(() => _selectedPatient = val),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Крок 2: Формування критеріїв цілі", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Expanded(
              child: ListView.builder(
                itemCount: _fields.length,
                itemBuilder: (context, index) {
                  final f = _fields[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: TextField(
                      controller: _controllers[f["key"]],
                      decoration: InputDecoration(
                        labelText: f["t"], hintText: f["h"],
                        labelStyle: const TextStyle(fontSize: 12),
                        hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600),
                onPressed: () {
                  if (_selectedPatient == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Спершу оберіть пацієнта")));
                    return;
                  }
                  if (_controllers["S"]!.text.isEmpty || _controllers["T"]!.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Критерії (S) та (T) є обов'язковими")));
                    return;
                  }

                  String goalText = "Ціль: ${_controllers["S"]!.text} "
                      "(${_controllers["M"]!.text.isEmpty ? 'без індикатора' : _controllers["M"]!.text}). "
                      "Термін: ${_controllers["T"]!.text}.";

                  _selectedPatient!.smartGoals.add(goalText);
                  widget.onGoalSaved();

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ціль додано до карти: ${_selectedPatient!.fullName}")));
                  for (var c in _controllers.values) { c.clear(); }
                },
                child: const Text("Зберегти ціль в карту пацієнта", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 5. ДОВІДНИК МКХ-10 З ЛОГІКОЮ ЗАКРІПЛЕННЯ
// ==========================================
class EmbeddedIcdScreen extends StatefulWidget {
  final List<PatientCard> patients;
  final VoidCallback onIcdAssigned;

  const EmbeddedIcdScreen({Key? key, required this.patients, required this.onIcdAssigned}) : super(key: key);

  @override
  State<EmbeddedIcdScreen> createState() => _EmbeddedIcdScreenState();
}

class _EmbeddedIcdScreenState extends State<EmbeddedIcdScreen> {
  String _searchQuery = "";
  PatientCard? _targetPatient;

  final List<Map<String, String>> _icdCodes = [
    {"code": "I69.3", "name": "Наслідки ішемічного інсульту головного мозку"},
    {"code": "G80.0", "name": "Спастичний церебральний параліч (ДЦП)"},
    {"code": "M16.0", "name": "Первинний коксартроз двобічний"},
    {"code": "M50.1", "name": "Ураження міжхребцевого диска шийного відділу з радикулопатією"},
    {"code": "S42.2", "name": "Перелом верхнього кінця плечової кістки"},
    {"code": "T90.5", "name": "Наслідки внутрішньочерепної травми"},
    {"code": "S32.0", "name": "Перелом поперекового хребця L1"},
    {"code": "G20", "name": "Хвороба Паркінсона"},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.patients.isNotEmpty) {
      _targetPatient = widget.patients.first;
    }
  }

  void _assignCode(String code) {
    if (_targetPatient == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Спершу виберіть або додайте пацієнта")));
      return;
    }

    if (_targetPatient!.icdCodes.contains(code)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Код $code вже є у картці пацієнта!")));
      return;
    }

    setState(() { _targetPatient!.icdCodes.add(code); });
    widget.onIcdAssigned();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Код $code успішно закріплено за пацієнтом: ${_targetPatient!.fullName}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _icdCodes.where((e) {
      return e["code"]!.toLowerCase().contains(_searchQuery.toLowerCase()) || e["name"]!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Довідник МКХ-10"), backgroundColor: Colors.amber.shade700, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Оберіть пацієнта для призначення коду:", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(8), color: Colors.white),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<PatientCard>(
                  value: _targetPatient,
                  isExpanded: true,
                  items: widget.patients.map((PatientCard p) {
                    return DropdownMenuItem<PatientCard>(value: p, child: Text(p.fullName, style: const TextStyle(fontSize: 13)));
                  }).toList(),
                  onChanged: (val) => setState(() => _targetPatient = val),
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              decoration: const InputDecoration(labelText: "Швидкий пошук за діагнозом чи кодом МКХ", prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text("Кодів за запитом не знайдено"))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final codeItem = filtered[index];
                        return Card(
                          child: ListTile(
                            leading: Chip(label: Text(codeItem["code"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)), backgroundColor: Colors.amber.shade100),
                            title: Text(codeItem["name"]!, style: const TextStyle(fontSize: 13)),
                            trailing: const Icon(Icons.add_link, color: Colors.amber),
                            onTap: () => _assignCode(codeItem["code"]!),
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

// ==========================================
// 6. ІНТЕРАКТИВНИЙ КАТАЛОГ ВПРАВ ТА ЛФК
// ==========================================
class ExercisesCatalogView extends StatefulWidget {
  final List<PatientCard> patients;
  final VoidCallback onExercisesUpdated;

  const ExercisesCatalogView({
    Key? key,
    required this.patients,
    required this.onExercisesUpdated,
  }) : super(key: key);

  @override
  State<ExercisesCatalogView> createState() => _ExercisesCatalogViewState();
}

class _ExercisesCatalogViewState extends State<ExercisesCatalogView> {
  String _searchQuery = "";
  String _selectedCategory = "Всі";
  PatientCard? _selectedPatient;

  final List<String> _categories = ["Всі", "Нейрореабілітація", "Ортопедія", "Дихальна", "Ерготерапія"];

  final List<Map<String, String>> _exercisesDb = [
    {
      "title": "Дзеркальна терапія для кисті",
      "cat": "Нейрореабілітація",
      "desc": "Стимуляція моторної кори головного мозку через зорову ілюзію здорової кінцівки.",
      "dose": "15 хвилин, 2 рази на день.",
      "warn": "Припинити при виникненні запаморочення чи ментального опору."
    },
    {
      "title": "PNF-патерни для верхньої кінцівки",
      "cat": "Нейрореабілітація",
      "desc": "Пропріоцептивна нейром'язова фасилітація (діагональні рухи) для відновлення координації.",
      "dose": "3 підходи по 10 повторень.",
      "warn": "Контролювати стабільність плечового суглоба, уникати підвивиху."
    },
    {
      "title": "Ізометричне скорочення чотириголового м'яза",
      "cat": "Ортопедія",
      "desc": "Напруження передньої поверхні стегна без руху в колінному суглобі (посттравматичний протокол).",
      "dose": "Утримання 5 сек, 3 підходи по 15 разів.",
      "warn": "Не затримувати дихання під час напруження."
    },
    {
      "title": "Мобілізація гомілковостопного суглоба з резинкою",
      "cat": "Ортопедія",
      "desc": "Збільшення амплітуди тильного згинання стопи за допомогою еластичного опору.",
      "dose": "20 повторень повільно, фіксація в кінцевій точці.",
      "warn": "Уникати гострого болю у зоні сухожилля."
    },
    {
      "title": "Діафрагмальне дихання з контролем видиху",
      "cat": "Дихальна",
      "desc": "Вентиляція нижніх часток легень, зниження активності допоміжних дихальних м'язів.",
      "dose": "5-7 хвилин у положенні лежачи або напівсидячи.",
      "warn": "При появі гіпервентиляції зробити паузу."
    },
    {
      "title": "Тренування циліндричного та щипкового захватів",
      "cat": "Ерготерапія",
      "desc": "Робота з дрібними предметами, конусами чи ерготерапевтичним пластиліном для відновлення побутових навичок.",
      "dose": "10 хвилин активних маніпуляцій.",
      "warn": "Стежити за правильним протиставленням великого пальця."
    }
  ];

  @override
  void initState() {
    super.initState();
    if (widget.patients.isNotEmpty) {
      _selectedPatient = widget.patients.first;
    }
  }

  void _assignExerciseToPatient(String exerciseTitle, String dosage) {
    if (_selectedPatient == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Оберіть пацієнта для призначення")));
      return;
    }

    String fullAssignment = "$exerciseTitle ($dosage)";
    
    if (_selectedPatient!.assignedExercises.contains(fullAssignment)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ця вправа вже є в програмі")));
      return;
    }

    setState(() { _selectedPatient!.assignedExercises.add(fullAssignment); });
    widget.onExercisesUpdated();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Вправу додано до програми пацієнта: ${_selectedPatient!.fullName}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _exercisesDb.where((ex) {
      final matchesCat = _selectedCategory == "Всі" || ex["cat"] == _selectedCategory;
      final matchesSearch = ex["title"]!.toLowerCase().contains(_searchQuery.toLowerCase()) || ex["desc"]!.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCat && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Каталог ЛФК та Призначення"), backgroundColor: Colors.purple.shade600, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("1. Оберіть пацієнта для формування комплексу:", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(8), color: Colors.white),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<PatientCard>(
                  value: _selectedPatient,
                  isExpanded: true,
                  items: widget.patients.map((PatientCard p) {
                    return DropdownMenuItem<PatientCard>(value: p, child: Text(p.fullName, style: const TextStyle(fontSize: 13)));
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedPatient = val),
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              decoration: const InputDecoration(labelText: "Пошук вправи за назвою чи показаннями", prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final c = _categories[index];
                  final isSelected = _selectedCategory == c;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: ChoiceChip(
                      label: Text(c, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 11)),
                      selected: isSelected,
                      selectedColor: Colors.purple.shade600,
                      onSelected: (val) => setState(() => _selectedCategory = c),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text("Вправ не знайдено"))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final ex = filtered[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ExpansionTile(
                            leading: Icon(Icons.fitness_center, color: Colors.purple.shade400),
                            title: Text(ex["title"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            subtitle: Text("Категорія: ${ex["cat"]}", style: const TextStyle(fontSize: 11)),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("📝 Опис: ${ex["desc"]}", style: const TextStyle(fontSize: 12)),
                                    const SizedBox(height: 4),
                                    Text("⏱️ Дозування: ${ex["dose"]}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green)),
                                    const SizedBox(height: 4),
                                    Text("⚠️ Застереження: ${ex["warn"]}", style: const TextStyle(fontSize: 12, color: Colors.redAccent)),
                                    const Divider(),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.purple.shade600),
                                        onPressed: () => _assignExerciseToPatient(ex["title"]!, ex["dose"]!),
                                        icon: const Icon(Icons.add, color: Colors.white, size: 16),
                                        label: const Text("Призначити пацієнту", style: TextStyle(color: Colors.white, fontSize: 12)),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
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
