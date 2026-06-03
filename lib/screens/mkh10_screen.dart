import 'package:flutter/material.dart';
import '../models.dart';

class Mkh10Screen extends StatefulWidget {
  final Function(String)? onSelectDiagnosis; // Функція зворотного зв'язку для передачі діагнозу в картку пацієнта

  const Mkh10Screen({super.key, this.onSelectDiagnosis});

  @override
  State<Mkh10Screen> createState() => _Mkh10ScreenState();
}

class _Mkh10ScreenState extends State<Mkh10Screen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _customDiagnosisController = TextEditingController();
  
  String _searchQuery = '';
  Map<String, String> _filteredCodes = {};

  @override
  void initState() {
    super.initState();
    // На старті відображаємо всі доступні коди з нашої клінічної бази даних
    _filteredCodes = Mkh10Data.commonCodes;
  }

  void _filterSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredCodes = Map.fromEntries(
        Mkh10Data.commonCodes.entries.where((entry) =>
            entry.key.toLowerCase().contains(_searchQuery) ||
            entry.value.toLowerCase().contains(_searchQuery)),
      );
    });
  }

  void _submitDiagnosis(String diagnosisText) {
    if (widget.onSelectDiagnosis != null) {
      widget.onSelectDiagnosis!(diagnosisText);
      Navigator.pop(context); // Закриваємо екран довідника та повертаємось до картки
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Діагноз успішно встановлено: $diagnosisText')),
      );
    } else {
      // Якщо довідник відкрили самостійно з Головного меню — просто показуємо вікно перегляду
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Клінічний діагноз'),
          content: Text(diagnosisText),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Закрити'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Довідник діагнозів МКХ-10'),
        backgroundColor: Colors.purple.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        key: const ValueKey('mkh10_screen_layout_root'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- СЕКЦІЯ 1: ІНТЕРАКТИВНИЙ ПОШУК ---
            const Text(
              'Швидкий пошук у базі реабілітації:',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.purple),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _searchController,
              onChanged: _filterSearch,
              decoration: InputDecoration(
                labelText: 'Введіть код МКХ або ключове слово',
                hintText: 'Наприклад: інсульт, перелом, M16',
                prefixIcon: const Icon(Icons.search, color: Colors.purple),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            
            // Динамічний список відфільтрованих результатів
            Expanded(
              flex: 3,
              child: _filteredCodes.isEmpty
                  ? Center(
                      child: Text(
                        'У вбудованій базі нічого не знайдено.\nВи можете ввести діагноз вручну у формі нижче 👇',
                        textAlign: Center,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.4),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredCodes.length,
                      itemBuilder: (context, index) {
                        String key = _filteredCodes.keys.elementAt(index);
                        String value = _filteredCodes[key]!;
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          elevation: 1,
                          child: ListTile(
                            leading: Chip(
                              label: Text(key, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13)),
                              backgroundColor: Colors.purple.shade400,
                              padding: EdgeInsets.zero,
                            ),
                            title: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            trailing: widget.onSelectDiagnosis != null 
                              ? const Icon(Icons.check_circle, color: Colors.green)
                              : const Icon(Icons.info_outline, color: Colors.grey),
                            onTap: () => _submitDiagnosis('[$key] $value'),
                          ),
                        );
                      },
                    ),
            ),
            
            const Divider(height: 24, thickness: 2),

            // --- СЕКЦІЯ 2: КЛІНІЧНЕ РУЧНЕ ВВЕДЕННЯ (БЕЗ ОБМЕЖЕНЬ) ---
            const Text(
              'Власна нотація діагнозу (якщо код відсутній):',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customDiagnosisController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: 'Впишіть діагноз, супутні патології чи операції',
                      hintText: 'Наприклад: G82.1 Спастична параплегія, стан після ТПС від 12.04.2026',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.deepOrange, width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    final text = _customDiagnosisController.text.trim();
                    if (text.isNotEmpty) {
                      _submitDiagnosis(text);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Будь ласка, введіть текст клінічного діагнозу')),
                      );
                    }
                  },
                  child: const Icon(Icons.playlist_add_check, size: 28),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _customDiagnosisController.dispose();
    super.dispose();
  }
}
