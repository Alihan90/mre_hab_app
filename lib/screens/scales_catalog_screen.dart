// lib/screens/scales_catalog_screen.dart
import 'package:flutter/material.dart';
import 'goniometry_test_screen.dart';

class ScalesCatalogScreen extends StatelessWidget {
  final Function(String, String)? onScaleTested; // Додали параметр для зв'язку з пацієнтом

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
            GoniometryInteractiveTestScreen(onSaveResult: onScaleTested), // Передаємо колбек сюди
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
            title: Text(group == "Child" ? "GMFCS — Універсальна система класифікації" : "BBS — Шкала балансу Берга"),
            subtitle: const Text("Оценочний інструмент балансу та ризику падінь"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {
              if (onScaleTested != null) {
                onScaleTested!(
                  group == "Child" ? "GMFCS" : "BBS", 
                  "Тест розпочато терапевтом"
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
