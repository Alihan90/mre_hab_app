// lib/exercises_screen.dart
import 'package:flutter/material.dart';
import 'models.dart'; // Імпортуємо структуру пацієнта

class ExercisesCatalogView extends StatefulWidget {
  final List<PatientCard> patients;
  final VoidCallback onExercisesUpdated;

  const ExercisesCatalogView({
    Key? key,
    required this.patients,
    required this.onExercisesUpdated,
  }) : super(key: key);

  @override
  State<ExercisesCatalogView> createState() => _ExercisesCatalogViewState();
}

class _ExercisesCatalogViewState extends State<ExercisesCatalogView> {
  String _searchQuery = "";
  String _selectedCategory = "Всі";
  PatientCard? _selectedPatient;

  final List<String> _categories = ["Всі", "Нейрореабілітація", "Ортопедія", "Дихальна", "Ерготерапія"];

  final List<Map<String, String>> _exercisesDb = [
    {
      "title": "Дзеркальна терапія для кисті",
      "cat": "Нейрореабілітація",
      "desc": "Стимуляція моторної кори головного мозку через зорову ілюзію здорової кінцівки.",
      "dose": "15 хвилин, 2 рази на день.",
      "warn": "Припинити при виникненні запаморочення чи ментального опору."
    },
    {
      "title": "PNF-патерни для верхньої кінцівки",
      "cat": "Нейрореабілітація",
      "desc": "Пропріоцептивна нейром'язова фасилітація (діагональні рухи) для відновлення координації.",
      "dose": "3 підходи по 10 повторень.",
      "warn": "Контролювати стабільність плечового суглоба, уникати підвивиху."
    },
    {
      "title": "Ізометричне скорочення чотириголового м'яза",
      "cat": "Ортопедія",
      "desc": "Напруження передньої поверхні стегна без руху в колінному суглобі (посттравматичний протокол).",
      "dose": "Утримання 5 сек, 3 підходи по 15 разів.",
      "warn": "Не затримувати дихання під час напруження."
    },
    {
      "title": "Мобілізація гомілковостопного суглоба з резинкою",
      "cat": "Ортопедія",
      "desc": "Збільшення амплітуди тильного згинання стопи за допомогою еластичного опору.",
      "dose": "20 повторень повільно, фіксація в кінцевій точці.",
      "warn": "Уникати гострого болю у зоні сухожилля."
    },
    {
      "title": "Діафрагмальне дихання з контролем видиху",
      "cat": "Дихальна",
      "desc": "Вентиляція нижніх часток легень, зниження активності допоміжних дихальних м'язів.",
      "dose": "5-7 хвилин у положенні лежачи або напівсидячи.",
      "warn": "При появі гіпервентиляції зробити паузу."
    },
    {
      "title": "Тренування циліндричного та щипкового захватів",
      "cat": "Ерготерапія",
      "desc": "Робота з дрібними предметами, конусами чи ерготерапевтичним пластиліном для відновлення побутових навичок.",
      "dose": "10 хвилин активних маніпуляцій.",
      "warn": "Стежити за правильним протиставленням великого пальця."
    }
  ];

  @override
  void initState() {
    super.initState();
    if (widget.patients.isNotEmpty) {
      _selectedPatient = widget.patients.first;
    }
  }

  void _assignExerciseToPatient(String exerciseTitle, String dosage) {
    if (_selectedPatient == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Оберіть пацієнта для призначення")));
      return;
    }

    String fullAssignment = "$exerciseTitle ($dosage)";
    
    if (_selectedPatient!.assignedExercises.contains(fullAssignment)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ця вправа вже є в програмі")));
      return;
    }

    setState(() { _selectedPatient!.assignedExercises.add(fullAssignment); });
    widget.onExercisesUpdated();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Вправу додано до програми пацієнта: ${_selectedPatient!.fullName}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _exercisesDb.where((ex) {
      final matchesCat = _selectedCategory == "Всі" || ex["cat"] == _selectedCategory;
      final matchesSearch = ex["title"]!.toLowerCase().contains(_searchQuery.toLowerCase()) || ex["desc"]!.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCat && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Каталог ЛФК та Призначення"), backgroundColor: Colors.purple.shade600, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("1. Оберіть пацієнта для формування комплексу:", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(8), color: Colors.white),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<PatientCard>(
                  value: _selectedPatient,
                  isExpanded: true,
                  items: widget.patients.map((PatientCard p) {
                    return DropdownMenuItem<PatientCard>(value: p, child: Text(p.fullName, style: const TextStyle(fontSize: 13)));
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedPatient = val),
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              decoration: const InputDecoration(labelText: "Пошук вправи за назвою чи показаннями", prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final c = _categories[index];
                  final isSelected = _selectedCategory == c;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: ChoiceChip(
                      label: Text(c, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 11)),
                      selected: isSelected,
                      selectedColor: Colors.purple.shade600,
                      onSelected: (val) => setState(() => _selectedCategory = c),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text("Вправ не знайдено"))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final ex = filtered[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ExpansionTile(
                            leading: Icon(Icons.fitness_center, color: Colors.purple.shade400),
                            title: Text(ex["title"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            subtitle: Text("Категорія: ${ex["cat"]}", style: const TextStyle(fontSize: 11)),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("📝 Опис: ${ex["desc"]}", style: const TextStyle(fontSize: 12)),
                                    const SizedBox(height: 4),
                                    Text("⏱️ Дозування: ${ex["dose"]}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green)),
                                    const SizedBox(height: 4),
                                    Text("⚠️ Застереження: ${ex["warn"]}", style: const TextStyle(fontSize: 12, color: Colors.redAccent)),
                                    const Divider(),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.purple.shade600),
                                        onPressed: () => _assignExerciseToPatient(ex["title"]!, ex["dose"]!),
                                        icon: const Icon(Icons.add, color: Colors.white, size: 16),
                                        label: const Text("Призначити пацієнту", style: TextStyle(color: Colors.white, fontSize: 12)),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
