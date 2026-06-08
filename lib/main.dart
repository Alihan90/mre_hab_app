// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Тимчасові заглушки для ваших екранів, щоб код відразу запускався.
// Коли створите відповідні файли, просто замініть ці класи на ваші імпорти:
class PatientsScreen extends StatelessWidget {
  const PatientsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Пацієнти")));
}

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
      // Делегати для повноцінної підтримки української розкладки та системних віджетів
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('uk', 'UA'), // Українська розкладка
        Locale('en', 'US'), // Англійська розкладка
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
