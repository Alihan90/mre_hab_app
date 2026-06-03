import 'package:flutter/material.dart';
import 'models.dart';
import 'screens/patients_screen.dart';
import 'screens/scales_catalog_screen.dart';
import 'screens/goniometer_screen.dart';
import 'screens/exercises_screen.dart';
import 'screens/mkh10_screen.dart';
import 'screens/irp_global_screen.dart';

void main() {
  runApp(const ComprehensiveRehabApp());
}

class ComprehensiveRehabApp extends StatelessWidget {
  const ComprehensiveRehabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Реабілітаційний Комплекс',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MainMenuScreen(),
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Головне Меню Терапевта', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.teal.shade100,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          children: [
            _buildMenuCard(context, 'Картки Пацієнтів', Icons.assignment_ind, Colors.teal, const PatientsScreen()),
            _buildMenuCard(context, 'Клінічні Шкали (16)', Icons.analytics, Colors.blue, const ScalesCatalogScreen()),
            _buildMenuCard(context, 'Цифровий Гоніометр', Icons.screen_rotation, Colors.orange, const GoniometerScreen()),
            _buildMenuCard(context, 'Комплекси Вправ', Icons.fitness_center, Colors.green, const ExercisesScreen()),
            _buildMenuCard(context, 'Довідник МКХ-10', Icons.menu_book, Colors.purple, const Mkh10Screen()),
            _buildMenuCard(context, 'Конструктор ІРП', Icons.architecture, Colors.red, const IrpGlobalScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, Color color, Widget nextScreen) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => nextScreen)),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
