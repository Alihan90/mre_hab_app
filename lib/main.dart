import 'package:flutter/material.dart';
import 'models.dart';
import 'screens/patients_screen.dart';
import 'screens/goniometer_screen.dart';
import 'screens/exercises_screen.dart';
import 'screens/mkh10_screen.dart';
import 'screens/irp_global_screen.dart';

void main() {
  runApp(const RehabilitationApp());
}

class RehabilitationApp extends StatelessWidget {
  const RehabilitationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Асистент Фізичного Терапевта',
      debugShowCheckedModeBanner: false,
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
  // Єдине глобальне сховище пацієнтів на рівні додатка для наскрізної синхронізації
  final List<Patient> _globalPatients = [
    Patient(
      id: '1',
      name: 'Іваненко Петро Миколайович',
      birthDate: '14.05.1974',
      diagnosisMkh10: '[I63] Інфаркт мозку (Ішемічний інсульт)',
      admissionDate: '20.05.2026',
      irp: IrpPlan(
        goalsSmart: 'Збільшити силу в паретичній правій нозі до 4 балів за MRC та самостійно проходити 50 метрів без опори до 15.07.2026.',
        mfkCodes: 'b730.2 (Помірне порушення сили м\'язів однієї половини тіла), d450.1 (Легке ускладнення ходьби).',
        rehabilitationCycle: 'Первинний',
        interventionPlan: 'Кінезіотерапія за методикою PNF, ортостатичні тренування, відновлення дрібної моторики кисті.',
        specialistName: 'Ковальчук О.В.',
      ),
    ),
  ];

  // Метод для примусового перемальовування інтерфейсу при зміні даних в інших екранах
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
            Text('Робочий стіл реабілітації', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
            Text('Комплексна автоматизована система', style: TextStyle(fontSize: 12, color: Colors.white70)),
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
            // Привітальний інформаційний блок
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
                            'Протоколи МОЗ України',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blue.shade900),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Автоматична калькуляція шкал, побудова Індивідуального реабілітаційного плану та швидкий експорт документів.',
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
              'Функціональні модулі системи:',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
            const SizedBox(height: 10),

            // Головна сітка плиток (Провідник додатку)
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  _buildMenuCard(
                    context,
                    title: 'Карти пацієнтів',
                    subtitle: 'Журнал візитів, тестування, звіти',
                    icon: Icons.assignment_ind,
                    color: Colors.blue.shade600,
                    destination: const PatientsScreen(),
                  ),
                  _buildMenuCard(
                    context,
                    title: 'Конструктор ІРП / МКФ',
                    subtitle: 'Цілі SMART та функціональний діагноз',
                    icon: Icons.gavel,
                    color: Colors.teal.shade600,
                    destination: IrpGlobalScreen(patients: _globalPatients, onUpdate: _refreshGlobalState),
                  ),
                  _buildMenuCard(
                    context,
                    title: 'База вправ',
                    subtitle: 'Мобілізація, вертикалізація, дозування',
                    icon: Icons.fitness_center,
                    color: Colors.green.shade600,
                    destination: const ExercisesScreen(),
                  ),
                  _buildMenuCard(
                    context,
                    title: 'Гоніометрія (ROM)',
                    subtitle: 'Вимірювач та анатомічний довідник',
                    icon: Icons.screen_rotation,
                    color: Colors.orange.shade700,
                    destination: const GoniometerScreen(),
                  ),
                  _buildMenuCard(
                    context,
                    title: 'Довідник МКХ-10',
                    subtitle: 'Клінічні коди та кастомний ввід',
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

  // Універсальний віджет для генерації елемента меню робочого столу
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
          // Усі переходи автоматично додають стрілку "Назад" в AppBar викликаного екрана
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
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
