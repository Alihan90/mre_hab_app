import 'package:flutter/material.dart';

class Mkh10Screen extends StatefulWidget {
  final Function(String)? onSelectDiagnosis;
  const Mkh10Screen({super.key, this.onSelectDiagnosis});

  @override
  State<Mkh10Screen> createState() => _Mkh10ScreenState();
}

class _Mkh10ScreenState extends State<Mkh10Screen> {
  final List<String> _mkhDatabase = [
    '[I63] Інфаркт мозку (Ішемічний інсульт)',
    '[I61] Внутрішньомозковий крововилив (Геморагічний інсульт)',
    '[T90] Наслідки черепно-мозкової травми',
    '[G35] Розсіяний склероз',
    '[M50] Ураження міжхребцевих дисків шийного відділу з радикулопатією',
    '[M51] Ураження міжхребцевих дисків інших відділів з мієлопатією',
    '[G80] Дитячий церебральний параліч (ДЦП)',
    '[S72] Перелом стегнової кістки (стан після МОС)',
    '[Z96.6] Наявність ортопедичних імплантатів суглобів (стан після Ендопротезування)',
  ];

  List<String> _filteredDatabase = [];
  final _searchController = TextEditingController();
  final _customInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredDatabase = _mkhDatabase;
  }

  void _filterSearch(String query) {
    setState(() {
      _filteredDatabase = _mkhDatabase
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Класифікатор МКХ-10'),
        backgroundColor: Colors.purple.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: _filterSearch,
              decoration: const InputDecoration(
                labelText: 'Швидкий пошук діагнозу',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _filteredDatabase.isEmpty
                  ? const Center(child: Text('Діагноз не знайдено в експрес-базі.'))
                  : ListView.builder(
                      itemCount: _filteredDatabase.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(_filteredDatabase[index], style: const TextStyle(fontSize: 14)),
                            trailing: widget.onSelectDiagnosis != null 
                                ? const Icon(Icons.check_circle, color: Colors.purple)
                                : null,
                            onTap: () {
                              if (widget.onSelectDiagnosis != null) {
                                widget.onSelectDiagnosis!(_filteredDatabase[index]);
                                Navigator.pop(context);
                              }
                            },
                          ),
                        );
                      },
                    ),
            ),
            const Divider(height: 30),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  const Text('Кастомне введення (якщо коду немає в списку):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _customInputController,
                    decoration: const InputDecoration(
                      hintText: 'Введіть код та назву вручну',
                      border: OutlineInputBorder(),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 44)),
                    onPressed: () {
                      if (_customInputController.text.isNotEmpty && widget.onSelectDiagnosis != null) {
                        widget.onSelectDiagnosis!(_customInputController.text.trim());
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Застосувати ручний ввід'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
