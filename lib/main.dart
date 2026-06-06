// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/patients_screen.dart';
import 'screens/scales_catalog_screen.dart'; // Імпортуємо наш каталог шкал та гоніометрії

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
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 28),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Привітання та статус терапевта
            Text(
              "Вітаємо, Фізичний терапевт!",
              style: TextStyle(
                fontSize: 22, 
                fontWeight: FontWeight.bold, 
                color: Colors.blue.shade900
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Оберіть необхідний інструмент або перейдіть до карти пацієнта",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),

            // Головна інтерактивна сітка робочого столу (6 плиток)
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

                  // 2. Новий модуль: Клінічні шкали та Гоніометр
                  _buildDashboardCard(
                    context,
                    title: "Клінічні шкали",
                    subtitle: "16 тестів та Гоніометрія",
                    icon: Icons.assignment,
                    color: Colors.indigo.shade600,
                    destination: const ScalesCatalogScreen(), // Відкриває автономний каталог шкал
                  ),

                  // 3. Модуль Вправ (План реабілітації)
                  _buildDashboardCard(
                    context,
                    title: "Комплекси вправ",
                    subtitle: "Призначення та ЛФК",
                    icon: Icons.fitness_center,
                    color: Colors.green.shade600,
                    destination: null, // Сюди підставиш свій екран вправ, коли він буде готовий
                  ),

                  // 4. Модуль Аналітики / Звітів
                  _buildDashboardCard(
                    context,
                    title: "Звіти динаміки",
                    subtitle: "Графіки відновлення",
                    icon: Icons.bar_chart,
                    color: Colors.amber.shade700,
                    destination: null,
                  ),

                  // 5. Довідник терапевта (Анатомія, норми рухів)
                  _buildDashboardCard(
                    context,
                    title: "Довідник",
                    subtitle: "Анатомічні стандарти",
                    icon: Icons.menu_book,
                    color: Colors.purple.shade600,
                    destination: null,
                  ),

                  // 6. Налаштування профілю/додатку
                  _buildDashboardCard(
                    context,
                    title: "Налаштування",
                    subtitle: "Конфігурація системи",
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

  // Універсальний конструктор віджетів-карток для Робочого столу
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Модуль '$title' знаходиться на стадії налаштування."),
                duration: const Duration(seconds: 1),
              ),
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
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 15,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11, 
                  color: Colors.grey.shade600,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
