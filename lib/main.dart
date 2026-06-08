// lib/main.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Імпортуємо всі наші нові модулі
import 'models.dart';
import 'patients_screen.dart';
import 'scales_screen.dart';
import 'goals_screen.dart';
import 'icd_screen.dart';
import 'exercises_screen.dart';

void main() {
  runApp(const RehabCompanionApp());
}

class RehabCompanionApp extends StatelessWidget {
  const RehabCompanionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rehab Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  List<PatientCard> _patients = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPatientsData();
  }

  // Завантаження списку пацієнтів із локальної пам'яті при старті додатка
  Future<void> _loadPatientsData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? patientsJson = prefs.getString('saved_patients_list');
      if (patientsJson != null) {
        final List<dynamic> decodedList = jsonDecode(patientsJson);
        setState(() {
          _patients = decodedList.map((item) => PatientCard.fromMap(item)).toList();
        });
      }
    } catch (e) {
      debugPrint("Помилка завантаження даних: $e");
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  // Збереження поточного стану списку пацієнтів у пам'ять телефону
  Future<void> _savePatientsData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> mapList = _patients.map((p) => p.toMap()).toList();
      await prefs.setString('saved_patients_list', jsonEncode(mapList));
    } catch (e) {
      debugPrint("Помилка збереження даних: $e");
    }
  }

  void _addPatient(PatientCard newPatient) {
    setState(() { _patients.add(newPatient); });
    _savePatientsData();
  }

  void _deletePatient(int index) {
    setState(() { _patients.removeAt(index); });
    _savePatientsData();
  }

  @override
  Widget build(BuildContext context) {
    // Список екранів, куди ми прокидаємо список пацієнтів та функції збереження
    final List<Widget> _screens = [
      PatientsRegistryScreen(
        patients: _patients,
        onPatientAdded: _addPatient,
        onPatientDeleted: _deletePatient,
      ),
      const ScalesCatalogScreen(),
      EmbeddedSmartGoalsScreen(
        patients: _patients,
        onGoalSaved: _savePatientsData,
      ),
      EmbeddedIcdScreen(
        patients: _patients,
        onIcdAssigned: _savePatientsData,
      ),
      ExercisesCatalogView(
        patients: _patients,
        onExercisesUpdated: _savePatientsData,
      ),
    ];

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo.shade700,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.folder_shared), label: 'Реєстр'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Шкали'),
          BottomNavigationBarItem(icon: Icon(Icons.track_changes), label: 'SMART'),
          BottomNavigationBarItem(icon: Icon(Icons.healing), label: 'МКХ-10'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'ЛФК'),
        ],
      ),
    );
  }
}
