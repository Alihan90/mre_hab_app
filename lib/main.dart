// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'models.dart';
import 'screens/patients_screen.dart';
import 'screens/goniometer_screen.dart';
import 'screens/exercises_screen.dart';
import 'screens/mkh10_screen.dart';
import 'screens/irp_global_screen.dart';
import 'screens/goniometry_test_screen.dart'; // НАШ НОВИЙ ІМПОРТ

void main() {
  runApp(const RehabilitationApp());
}

class RehabilitationApp extends StatelessWidget {
  const RehabilitationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Асистент Фізичного Терапевта",
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale('uk', 'UA'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      home: const MainDashboardScreen(),
    );
  }
}

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  // Єдине глобальне сховище пацієнтів на рівні всього додатка
  final List<Patient> _globalPatients = [
    Patient(
      id: "1",
      name: "Іваненко Петро Миколайович",
      birthDate: "14.05.1974",
      diagnosisMkh10: "[I63] Інфаркт мозку (Ішемічний інсульт)",
      admissionDate: "20.05.2026",
      irp: IrpPlan(
        goalsSmart: "Збільшити силу в паретичній правій нозі до 4 балів за MRC та самостійно проходити 50 метров без опори до 15.07.2026.",
        mfkCodes: "b730.2 (Помірне порушення сили м'язів однієї половини тіла), d450.1 (Легке ускладнення ходьби).",
        rehabilitationCycle: "Первинний",
        interventionPlan: "Кінезіотерапія за методикою PNF, ортостатичні тренування, відновлення дрібної моторики кисті.",
        specialistName: "Ковальчук О.В.",
      ),
    ),
  ];

  // Метод для швидкого оновлення інтерфейсу
  void _refreshGlobalState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Робочий стіл реабілітації", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
            Text("Комплексна автоматизована система", style: TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        backgroundColor: Colors.blue.shade700,
        centerTitle: false,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.blue.shade50,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  children: [
                    Icon(Icons.health_and_safety, size: 40, color: Colors.blue.shade800),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Протоколи МОЗ України",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blue.shade900),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Автоматична калькуляція шкал, побудова Індивідуального реабілітаційного плану та швидкий експорт документів.",
                            style: TextStyle(fontSize: 11, color: Colors.black87, height: 1.3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            const Text(
              "Функціональні модулі системи:",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.05, // Трішки збільшив коефіцієнт для кращого падіння тексту
                children: [
                  _buildMenuCard(
                    context,
                    title: "Карти пацієнтів",
                    subtitle: "Журнал візитів, тестування (16 шкал), звіти",
                    icon: Icons.assignment_ind,
                    color: Colors.blue.shade600,
                    destination: const PatientsScreen(),
                  ),
                  _buildMenuCard(
                    context,
                    title: "Конструктор ІРП / МКФ",
                    subtitle: "Цілі SMART та функціональний діагноз",
                    icon: Icons.gavel,
                    color: Colors.teal.shade600,
                    destination: IrpGlobalScreen(patients: _globalPatients, onUpdate: _refreshGlobalState),
                  ),
                  _buildMenuCard(
                    context,
                    title: "База вправ",
                    subtitle: "Мобілізація, вертикалізація, дозування",
                    icon: Icons.fitness_center,
                    color: Colors.green.shade600,
                    destination: const ExercisesScreen(),
                  ),
                  
                  // ОНОВЛЕНИЙ ПУНКТ ГОНІОМЕТРІЇ: ТЕПЕР ВІДКРИВАЄ НАШ ІНТЕРАКТИВНИЙ ТЕСТ З ДОВІДНИКОМ
                  _buildMenuCard(
                    context,
                    title: "Тест Гоніометрії (ROM)",
                    subtitle: "Вимірювання суглобів, норми та збереження в карту",
                    icon: Icons.straighten,
                    color: Colors.orange.shade700,
                    destination: const GoniometryInteractiveTestScreen(),
                  ),
                  
                  _buildMenuCard(
                    context,
                    title: "Довідник МКХ-10",
                    subtitle: "Клінічні коди та кастомний ввід",
                    icon: Icons.library_books,
                    color: Colors.purple.shade600,
                    destination: const Mkh10Screen(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget destination,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          ).then((_) => _refreshGlobalState());
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
                child: Icon(icon, size: 28, color: color),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, height: 1.2),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600, height: 1.2),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Старий клас ClinicalScale залишаємо без змін для сумісності
class ClinicalScale {
  final String id;
  final String name;
  final String purpose;
  final String method;

  const ClinicalScale({
    required this.id,
    required this.name,
    required this.purpose,
    required this.method,
  });
}

class ClinicalScalesData {
  static const List<ClinicalScale> allScales = [
    ClinicalScale(
      id: "mrc",
      name: "MRC-SumScore",
      purpose: """Оценочна шкала для вимірювання сили скелетних м'язів у пацієнтів з руховими порушеннями.""",
      method: """Тестуються 6 м'язових груп симетрично з обох боків. Кожна група оцінюється від 0 (відсутність скорочення) до 5 (нормальна сила). Максимальна сума становить 60 балів.""",
    ),
    ClinicalScale(
      id: "bbs",
      name: "Berg Balance Scale (BBS)",
      purpose: """Клінічна оцінка статичного та динамічного балансу, а також визначення ризику падіння.""",
      method: """Включає 14 стандартних завдань (вставання, стояння без опори, заплющені очі, повороти тощо). Кожне завдання оцінюється від 0 до 4 балів. Максимум 56 балів.""",
    ),
    ClinicalScale(
      id: "rmi",
      name: "Rivermead Mobility Index (RMI)",
      purpose: """Оцінка рівня мобільності та базових рухових навичок у повсякденному житті.""",
      method: """Складається з 14 питань до пацієнта та 1 візуального тесту на стояння. Охоплює діапазон від повертання в ліжку до підйому по сходах. За кожне 'так' — 1 бал. Максимум — 15 балів.""",
    ),
    ClinicalScale(
      id: "bi",
      name: "Barthel Index (BI)",
      purpose: """Оцінка ступеня повсякденної незалежності пацієнта та потребности у сторонньому догляді.""",
      method: """Аналізуються 10 функцій життєдіяльності (харчування, гігієна, пересування тощо). Оцека варіюється від 0 до 100 балів. Нижчі бали вказують на більшу залежність.""",
    ),
    ClinicalScale(
      id: "fim",
      name: "FIM (Functional Independence Measure)",
      purpose: """Комплексне вимірювання фізичної та когнітивної самостійності в процесі реабілітації.""",
      method: """Оцінюється 18 сфер (13 рухових та 5 когнітивних). Застосовується 7-бальна шкала для кожного пункту (від повної залежності до повної самостійності). Загальний бал від 18 до 126.""",
    ),
    ClinicalScale(
      id: "6mwt",
      name: "6-Minute Walk Test (6MWT)",
      purpose: """Оцінка аеробної спроможності, витривалості серцево-судинної та дихальної систем.""",
      method: """Пацієнту пропонується пройти якомога більшу відстань у комфортному темпі за 6 хвилин. Дозволені зупинки. Фіксується загальний метраж, ЧСС та уровень задишки.""",
    ),
    ClinicalScale(
      id: "tug",
      name: "Timed Up and Go (TUG)",
      purpose: """Експрес-оцінка динамічного балансу, швидкості ходьби та базової мобільності.""",
      method: """Пацієнт за командою встає зі стільця, проходить 3 метри вперед, розвертається, повертається назад і сідає на стілець. Час заміряється секундоміром.""",
    ),
    ClinicalScale(
      id: "poma",
      name: "Tinetti Performance Oriented Mobility Assessment (POMA)",
      purpose: """Специфічна оцінка ходьби та рівноваги для визначення рухового дефіциту.""",
      method: """Складається з двох секцій: баланс (9 завдань, макс. 16 балів) і ходьба (8 параметрів, макс. 12 балів). Сумарна оцінка — 28 балів.""",
    ),
    ClinicalScale(
      id: "dgi",
      name: "Dynamic Gait Index (DGI)",
      purpose: """Аналіз здатності пацієнта адаптувати ходьбу до зміни зовнішніх умов та вимог.""",
      method: """Терапевт оцінює 8 завдань під час локомоції: зміна швидкості, повороти голови, переступання перешкод, підйом по сходах. Оцінка від 0 до 24 балів.""",
    ),
    ClinicalScale(
      id: "fma",
      name: "Fugl-Meyer Assessment (FMA)",
      purpose: """Глибока кількісна оцінка рухового відновлення, рефлексів та чутливості після інсульту.""",
      method: """Детальний огляд, що оцінює окремо верхню (макс. 66 балів) та нижню кінцівку (макс. 34 бали), координацію, рефлекторну діяльність та пасивний об'єм рухів.""",
    ),
    ClinicalScale(
      id: "mas",
      name: "Modified Ashworth Scale (MAS)",
      purpose: """Визначення ступеня спастичності та тонусу м'язів під час пасивного розтягнення.""",
      method: """Терапевт виконує швидкий пасивний рух у суглобі в напрямку розтягнення м'яза. Оцінюється опір за шкалою від 0 (немає підвищення тонусу) до 4 (суглоб повністю ригідний).""",
    ),
    ClinicalScale(
      id: "arat",
      name: "Action Research Arm Test (ARAT)",
      purpose: """Оцінка функції верхньої кінцівки, дрібної моторики, захвату та маніпуляцій з предметами.""",
      method: """Включає 19 тестів, розділених на 4 блоки: макрозахват, щипковий захват, утримання та загальні великі рухи. Максимум — 57 балів.""",
    ),
    ClinicalScale(
      id: "fat",
      name: "Frenchay Arm Test (FAT)",
      purpose: """Швидкий скринінг функціонального використання ураженої руки в побутових умовах.""",
      method: """Пацієнт виконує 5 практичних завдань ураженою рукою (розчісування, наливання води тощо). Кожне успішне завдання — 1 бал. Максимум 5 балів.""",
    ),
    ClinicalScale(
      id: "frt",
      name: "Functional Reach Test (FRT)",
      purpose: """Оцінка меж стабільності пацієнта у положенні стоячи без зміни площі опори.""",
      method: """Пацієнт стоїть біля стіни, піднімає руку на 90 градусів і тягнеться вперед максимально далеко, не відриваючи п'яти від підлоги. Фіксується відстань у сантиметрах.""",
    ),
    ClinicalScale(
      id: "sppb",
      name: "Short Physical Performance Battery (SPPB)",
      purpose: """Комплексна експрес-оцінка сили ніг, балансу та швидкості ходьби у літніх пацієнтів.""",
      method: """Складається з трьох блоків: тест рівноваги (3 положення), тест швидкості ходьби на 4 метри та тест 5-разового вставання зі стільця. Максимум — 12 балів.""",
    ),
    ClinicalScale(
      id: "tct",
      name: "Trunk Control Test (TCT)",
      purpose: """Оцінка контролю та стабільності м'язів тулуба у пацієнтів на ранніх етапах після інсульту.""",
      method: """Досліджуються 4 прості рухові операції в ліжку: повороти на боки, підйом у положення сидячи та утримання балансу протягом 30 секунд. Максимум 100 балів.""",
    ),
  ];
}
