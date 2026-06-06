import 'package:flutter/material.dart';
import 'goniometry_test_screen.dart'; // Підключаємо наш новий екран тесту

class ScalesCatalogScreen extends StatelessWidget {
  const ScalesCatalogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Клінічні оцінки та шкали"),
          backgroundColor: Colors.teal,
          bottom: const TabBar(
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
            _buildScalesCategoryList(context, "Child"),
            _buildScalesCategoryList(context, "Adult"),
            const GoniometryInteractiveTestScreen(), // Вставляємо тест третьою вкладкою
          ],
        ),
      ),
    );
  }

  Widget _buildScalesCategoryList(BuildContext context, String ageGroup) {
    // Твій список категорій (Неврологія, Ортопедія тощо) відповідно до ТЗ
    final List<Map<String, String>> categories = ageGroup == "Child" 
      ? [
          {"title": "🧠 Неврологія та ДЦП", "desc": "GMFCS, GMFM-66/88, MACS, WeeFIM..."},
          {"title": "🦴 Ортопедія та Біль", "desc": "FLACC, Wong-Baker, PODCI..."},
          {"title": "🗣️ Розвиток та Комунікація", "desc": "Bayley-III, CARS, VABS, CFCS..."},
        ]
      : [
          {"title": "🧠 Неврологія та Штрих", "desc": "NIHSS, Індекс Бартел, Берг, Ашворт..."},
          {"title": "🦴 Ортопедія та Травма", "desc": "VAS, WOMAC, DASH, Опитувальник Освестрі..."},
          {"title": "🫁 Кардіо-респіраторна", "desc": "6MWT, Шкала Борга, mMRC, NYHA..."},
          {"title": "🍽️ Логопедія та Дисфагія", "desc": "GUSS screening, MASA, FOIS..."},
        ];

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            title: Text(cat["title"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(cat["desc"]!),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.teal),
            onTap: () {
              // Логіка переходу до списку конкретних інтерактивних шкал цієї категорії
            },
          ),
        );
      },
    );
  }
}
