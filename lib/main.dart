// lib/main.dart
import 'package:flutter/material.dart';

// Імпортуємо ВСІ твої робочі екрани
import 'screens/patients_screen.dart';
import 'screens/scales_catalog_screen.dart';
import 'screens/icd_screen.dart';           // Твій екран МКХ-10
import 'screens/smart_goals_screen.dart';   // Твій конструктор цілей SMART

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
      home: const MainDashboardScreen(),
    );
  }
}

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
            Text(
              "Вітаємо, Фізичний терапевт!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
            ),
            const SizedBox(height: 4),
            Text(
              "Усі професійні модулі відновлено та підключено:",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),

            // Головна інтерактивна сітка робочого столу
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                children: [
                  // 1. Модуль Пацієнтів
                  _buildDashboardCard(
                    context,
                    title: "Пацієнти",
                    subtitle: "База та Журнал карт",
                    icon: Icons.people,
                    color: Colors.blue.shade600,
                    destination: const PatientsScreen(),
                  ),

                  // 2. Клінічні шкали (Твій повний список)
                  _buildDashboardCard(
                    context,
                    title: "Клінічні шкали",
                    subtitle: "16 тестів та Гоніометрія",
                    icon: Icons.assignment,
                    color: Colors.indigo.shade600,
                    destination: const ScalesCatalogScreen(),
                  ),

                  // 3. Смарт конструктор цілей (SMART)
                  _buildDashboardCard(
                    context,
                    title: "Конструктор цілей",
                    subtitle: "SMART критерії",
                    icon: Icons.track_changes,
                    color: Colors.green.shade600,
                    destination: const SmartGoalsScreen(), // ПІДКЛЮЧЕНО!
                  ),

                  // 4. Класифікатор МКХ-10
                  _buildDashboardCard(
                    context,
                    title: "МКХ-10 / МКФ",
                    subtitle: "Діагностичні коди",
                    icon: Icons.assignment_turned_in,
                    color: Colors.amber.shade700,
                    destination: const IcdScreen(), // ПІДКЛЮЧЕНО!
                  ),

                  // 5. Комплекси вправ (ЛФК)
                  _buildDashboardCard(
                    context,
                    title: "Вправи та ЛФК",
                    subtitle: "Протоколи занять",
                    icon: Icons.fitness_center,
                    color: Colors.purple.shade600,
                    destination: null, // Додамо екран, як тільки створимо його файл
                  ),

                  // 6. Налаштування системи
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
