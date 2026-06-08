import 'package:flutter/material.dart';
import 'models.dart';
import 'screens/patients_screen.dart';
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
      title: 'Rehabilitation App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // Глобальний список пацієнтів, який передається між екранами
  final List<Patient> _patients = [];

  void _refreshState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Навігаційна структура додатка (Реєстр та Конструктор ІРП)
    final List<Widget> screens = [
      PatientsScreen(
        patients: _patients,
        onUpdate: _refreshState,
      ),
      IrpGlobalScreen(
        patients: _patients,
        onUpdate: _refreshState,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal.shade700,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Реєстр пацієнтів',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Конструктор ІРП',
          ),
        ],
      ),
    );
  }
}
