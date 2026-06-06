// lib/screens/scales_catalog_screen.dart
import 'package:flutter/material.dart';
import 'goniometry_test_screen.dart';

class ScalesCatalogScreen extends StatelessWidget {
  final Function(String, String)? onScaleTested;

  const ScalesCatalogScreen({Key? key, this.onScaleTested}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Клінічні оцінки та шкали"),
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.child_care), text: "Дитячі"),
              Tab(icon: Icon(Icons.accessibility), text: "Дорослі"),
              Tab(icon: Icon(Icons.straighten), text: "Тест гоніометрії"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCatalogList("Child"),
            _buildCatalogList("Adult"),
            // Передаємо колбек збереження в наш розширений екран
            GoniometryInteractiveTestScreen(onSaveResult: onScaleTested), 
          ],
        ),
      ),
    );
  }

  Widget _buildCatalogList(String group) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Card(
          child: ListTile(
            leading: const CircleAvatar(child: Text("Б")),
            title: Text(group == "Child" ? "GMFCS — Система класифікації моторики" : "BBS — Шкала балансу Берга"),
            subtitle: const Text("Стандартизований клінічний тест"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {
              if (onScaleTested != null) {
                onScaleTested!(group == "Child" ? "GMFCS" : "BBS", "Проведено базовий тест клінічної оцінки");
              }
            },
          ),
        ),
      ],
    );
  }
}
