// lib/scales_screen.dart
import 'package:flutter/material.dart';
import 'models.dart'; // Импортируем наши структуры данных

class ScalesCatalogScreen extends StatefulWidget {
  const ScalesCatalogScreen({Key? key}) : super(key: key);

  @override
  State<ScalesCatalogScreen> createState() => _ScalesCatalogScreenState();
}

class _ScalesCatalogScreenState extends State<ScalesCatalogScreen> {
  String _searchQuery = "";
  String _selectedCategory = "Всі";

  final List<String> _categories = ["Всі", "Неврологія (дорослі)", "Ортопедія та Травматологія", "Кардіо-респіраторна", "Загальнофункциональні", "Pediatria (Дитячі вікові)", "Інструменти"];

  final List<ClinicalScale> _scales = [
    ClinicalScale(
      name: "Модифікована шкала спастичності Ашворт (MAS)",
      category: "Неврологія (дорослі)",
      description: "Оцінка м'язового тонусу та спастичності при дослідженні пасивних рухів кінцівок.",
      instruction: "Проведіть пасивне згинання/розгинання кінцівки у швидкому темпі. Оцініть опір.",
      interpretation: "0: Тонус не підвищений\n1: Легке підвищення (наприкінці руху)\n1+: Легке підвищення (менше половини амплітуди)\n2: Помірне підвищення тонусу, але рух легкий\n3: Значне підвищення тонусу, пасивний рух ускладнений\n4: Уражена結晶 частина ригідна",
    ),
    ClinicalScale(
      name: "Шкала інсульту Національного інституту здоров'я (NIHSS)",
      category: "Неврологія (дорослі)",
      description: "Клінічна оцінка тяжкості неврологічного дефіциту у пацієнтів з гострим інсультом.",
      instruction: "Оцініть за чергою 11 параметрів: свідомість, погляд, поля зору, парез обличчя, сила рук/ніг, атаксія, чутливість, мова, дизартрія, ігнорування.",
      interpretation: "0-4 балів: Легкий ступінь інсульту\n5-15 балів: Помірний інсульт\n16-20 балів: Середньо-важкий інсульт\n21-42 балів: Важкий інсульт",
    ),
    ClinicalScale(
      name: "Модифікована шкала Ренкіна (mRS)",
      category: "Неврологія (дорослі)",
      description: "Оцінка ступеня інвалідизазации та загальної незалежності пацієнта після судинних катастроф.",
      instruction: "Шляхом клінічного опитування виявіть уровень обмеження повсякденної життєдіяльності.",
      interpretation: "0: Немає симптомів\n1: Є симптомів, але без обмежень\n2: Легка інвалідність\n3: Помірна інвалідність\n4: Важка інвалідність\n5: Дуже важка (прикутий до ліжка)",
    ),
    ClinicalScale(
      name: "Тест оцінки функції руки Френчай (Frenchay Arm Test)",
      category: "Неврологія (дорослі)",
      description: "Оцінка проксимальної та дистальної рухової функції паретичної верхньої кінцівки.",
      instruction: "Запропонуйте виконати 5 побутових завдань. Кожен успіх — 1 бал.",
      interpretation: "0 балів: Рука повністю нефункциональна\n5 балів: Повна збережена функція руки",
    ),
    ClinicalScale(
      name: "Шкала коми Глазго (GCS)",
      category: "Неврологія (дорослі)",
      description: "Оцінка ступеня пригнічення свідомості та глибини коми.",
      instruction: "Сумуйте бали за трьома тестами: розплющування очей (1-4), мовна реакція (1-5), рухова реакція (1-6).",
      interpretation: "15 балів: Ясна свідомість\n13-14 балів: Оглушення\n9-12 балів: Сопор\n3-8 балів: Кома",
    ),
    ClinicalScale(
      name: "Індекс життєдіяльності Освестрі (ODI)",
      category: "Ортопедія та Травматологія",
      description: "Оцінка впливу больового синдрому в попереку на повсякденне життя.",
      instruction: "Оцініть 10 секцій життєдіяльності від 0 до 5 балів.",
      interpretation: "0-20%: Мінімальне обмеження\n21-40%: Помірне\n41-60%: Важке\n61-80%: Критичне\n81-100%: Повна залежність",
    ),
    ClinicalScale(
      name: "Візуально-аналогова шкала болю (VAS / ЧРШ)",
      category: "Ортопедія та Травматологія",
      description: "Суб'єктивний метод експрес-оцінки інтенсивності болю пацієнтом.",
      instruction: "Запропонуйте пацієнту обрати цифрове значення від 0 до 10.",
      interpretation: "1-3 бали: Слабкий біль\n4-6 балів: Помірний біль\n7-10 балів: Сильний біль",
    ),
    ClinicalScale(
      name: "Мануальне м'язове тестування (MMT за Ловеттом)",
      category: "Ортопедія та Травматологія",
      description: "Оцінка сили та витривалості окремих м'язових груп за 5-бальною системою.",
      instruction: "Протестуйте рух м'яза проти сили тяжіння та проти ручного супротиву терапевта.",
      interpretation: "0: Скорочення немає\n1: Слід скорочення\n2: Рух БЕЗ сили тяжіння\n3: Рух проти сили тяжіння\n4: Рух проти опору\n5: Норма",
    ),
    ClinicalScale(
      name: "Тест 6-хвилинної ходьби (6MWT)",
      category: "Кардіо-респіраторна",
      description: "Оцінка толерантності до фізичних навантажень та кардіореспіраторного статусу.",
      instruction: "Виміряйте максимальну відстань (у метрах), яку пацієнт здатний пройти за 6 хвилин.",
      interpretation: "Результат оцінюється індивідуально за віковими таблицями та у динаміці.",
    ),
    ClinicalScale(
      name: "Борг Шкала Сприйняття Навантаження (RPE Borg Scale)",
      category: "Кардіо-респіраторна",
      description: "Суб'єктивная оцінка фізичного напруження та задишки під час занять ЛФК.",
      instruction: "Пацієнт оцінює свою втому під час навантаження від 6 до 20.",
      interpretation: "6-11: Легке навантаження\n12-14: Помірний рівень (цільова зона кардіо-реабілітації)\n15-18: Важке навантаження\n19-20: Максимум",
    ),
    ClinicalScale(
      name: "Індекс задишки за шкалою MRC (Dyspnea Scale)",
      category: "Кардіо-респіраторна",
      description: "Оцінка ступеня задишки при хронічних легеневих або серцевих патологіях.",
      instruction: "Опитайте пацієнта про побутові умови виникнення відчуття нестачі повітря.",
      interpretation: "Грейд 0: При сильному навантаженні\nГрейд 1: При швидкій ходьбі\nГрейд 2: Ходить повільніше за однолітків\nГрейд 3: Зупиняється після 100 метрів\nГрейд 4: Задишка при одяганні",
    ),
    ClinicalScale(
      name: "Індекс активності повсякденного життя Бартел (Barthel Index)",
      category: "Загальнофункциональні",
      description: "Клінічний стандарт оцінки базової незалежності та самообслуговування пацієнта.",
      instruction: "Оцініть 10 пунктів щоденної активності.",
      interpretation: "0-20 б: Повна залежність\n21-60 б: Тяжка залежність\n61-90 б: Помірна залежність\n91-100 б: Повна функціональна незалежність",
    ),
    ClinicalScale(
      name: "Шкала рівноваги Берга (Berg Balance Scale)",
      category: "Загальнофункциональні",
      description: "Комплексний тест статичної та динамічної рівноваги, визначення ризику падінь.",
      instruction: "Попросіть виконати 14 рухових завдань. Оцінка від 0 до 4 кожне.",
      interpretation: "0-20 балів: Високий ризик падінь\n21-40 балів: Середній ризик падінь\n41-56 балів: Низький ризик",
    ),
    ClinicalScale(
      name: "Індекс мобільності Рівермід (RMI)",
      category: "Загальнофункциональні",
      description: "Скринінгова оцінка рівня мобільності від базових поворотів у ліжку до бігу.",
      instruction: "Оцініть 15 дій дії. За кожне «Так» — 1 бал.",
      interpretation: "0 балів: Повна нерухомість\n15 балів: Максимальна мобільність",
    ),
    ClinicalScale(
      name: "Тест «Встань та йди» (Timed Up and Go - TUG)",
      category: "Загальнофункциональні",
      description: "Швидкий функціональний тест для оцінки динамічного балансу.",
      instruction: "Засічіть час, за який пацієнт встане зі стільця, пройде 3 метри, розвернеться і сяде назад.",
      interpretation: "< 10 сек: Норма\n11-20 сек: Початкові порушення\n> 20 сек: Виражені порушення, високий ризик падінь",
    ),
    ClinicalScale(
      name: "Тест кубиків у коробці (Box and Block Test)",
      category: "Загальнофункциональні",
      description: "Оцінка грубої мануальної спритності та координації рухів.",
      instruction: "Підрахуйте кількість кубиків, перенесених по одному через перегородку за 60 секунд.",
      interpretation: "Показники порівнюють із віковими нормами.",
    ),
    ClinicalScale(
      name: "Функціональні категорії ходьби (FAC)",
      category: "Загальнофункциональні",
      description: "Класифікація рівня незалежності пацієнта під час ходьби.",
      instruction: "Визначте ступінь участі рук терапевта при страховці ходьби пацієнта на 3 метрах.",
      interpretation: "0: Не ходит\n1-2: Потрібна безперервна фізична підтримка\n3: Потрібен лише вербальний нагляд\n4-5: Самостійна ходьба",
    ),
    ClinicalScale(
      name: "Динамічний індекс ходьби (DGI)",
      category: "Загальнофункциональні",
      description: "Дослідження здатності пацієнта адаптувати ходьбу під складні умови.",
      instruction: "Оцініть 8 завдань (зміна темпу, повороти голови, перешкоди, сходи).",
      interpretation: "< 19 балів із 24: Висока ймовірність падінь",
    ),
    ClinicalScale(
      name: "Велика моторна функція (GMFM-88 / GMFM-66)",
      category: "Pediatria (Дитячі вікові)",
      description: "Стандартизований тест кількісної оцінки змін великої моторики у дітей з ДЦП.",
      instruction: "Проведіть тестування за 5 функціональними блоками: від лежання до бігу.",
      interpretation: "Розраховується відсотковий показник виконання завдань.",
    ),
    ClinicalScale(
      name: "Шкала оцінки болю у дітей FLACC",
      category: "Pediatria (Дитячі вікові)",
      description: "Поведінкова шкала оцінки інтенсивності болю у дітей (від 2 міс до 7 років).",
      instruction: "Спостерігайте 1-5 хв. Оцініть обличчя, ноги, активність, крик, втішання від 0 до 2 балів.",
      interpretation: "0 б: Спокій\n1-3 б: Легкий дискомфорт\n4-6 б: Помірний біль\n7-10 б: Сильний біль",
    ),
    ClinicalScale(
      name: "Шкала моторного розвитку немовлят Альберти (AIMS)",
      category: "Pediatria (Дитячі вікові)",
      description: "Оцінка моторного дозрівання малюків від народження до самостійної ходьби (0-18 місяців).",
      instruction: "Спостерігайте за активністю дитини у 4 положеннях: на животі, на спині, сидячи та стоячи.",
      interpretation: "Показник нижче 5-го перцентиля свідчить про затримку розвитку.",
    ),
    ClinicalScale(
      name: "Тест розвитку зорово-моторної інтеграції Ерхардта (EDVA)",
      category: "Pediatria (Дитячі вікові)",
      description: "Оцінка специфічних компонентів рухів рук та зорово-моторної координації у дітей.",
      instruction: "Перевірте мимовільні та довільні реакції: фіксація погляду, простежування, захоплення.",
      interpretation: "Визначається відповідність поточної рухової функції паспортному віку дитини.",
    ),
    ClinicalScale(
      name: "📐 Інструмент: Гоніометрія (Суглобовий статус за ROM)",
      category: "Інструменти",
      description: "Калькулятор дефіциту амплітуди активних та пасивних рухів у суглобах кінцівок.",
      instruction: "Введіть стандартну анатомічну норму для руху та фактичний показник кута.",
      interpretation: "Розрахунок дефіциту кута в градусах та відсотках відхилення від фізіологічної норми.",
    ),
  ];

  void _openScaleDetail(ClinicalScale scale) {
    if (scale.category == "Інструменти") {
      _openGoniometryCalculator();
      return;
    }

    final scoreController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 20, left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Chip(
                label: Text(scale.category, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                backgroundColor: Colors.indigo.shade600,
              ),
              const SizedBox(height: 5),
              Text(scale.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo)),
              const Divider(),
              const Text("📋 Опис:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(scale.description, style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 10),
              const Text("🚀 Методика проведення:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(scale.instruction, style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 10),
              const Text("🔍 Інтерпретація результатів:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
                child: Text(scale.interpretation, style: const TextStyle(fontSize: 12, fontFamily: 'Courier')),
              ),
              const SizedBox(height: 15),
              const Text("🔢 Фіксація балів:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: scoreController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Результат / бали", border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                    onPressed: () {
                      if (scoreController.text.isNotEmpty) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Результат оцінки (${scoreController.text}) зафіксовано")),
                        );
                      }
                    },
                    child: const Text("Оцінити", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  void _openGoniometryCalculator() {
    final normController = TextEditingController();
    final factController = TextEditingController();
    String resultString = "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 20, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("📐 Калькулятор гоніометрії (ROM)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo)),
              const Divider(),
              Row(
                children: [
                  Expanded(child: TextField(controller: normController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Норма (°)", border: OutlineInputBorder()))),
                  const SizedBox(width: 10),
                  Expanded(child: TextField(controller: factController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Кут пацієнта (°)", border: OutlineInputBorder()))),
                ],
              ),
              const SizedBox(height: 15),
              if (resultString.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.red.shade200)),
                  child: Text(resultString, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 13)),
                ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey), onPressed: () => Navigator.pop(context), child: const Text("Закрити", style: TextStyle(color: Colors.white)))),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                      onPressed: () {
                        final double? norm = double.tryParse(normController.text);
                        final double? fact = double.tryParse(factController.text);
                        if (norm != null && fact != null && norm > 0) {
                          final double deficitDeg = norm - fact;
                          final double deficitPct = (deficitDeg / norm) * 100;
                          setModalState(() {
                            resultString = "Дефіцит амплітуди рухів:\n🔻 ${deficitDeg.toStringAsFixed(1)}° (${deficitPct.toStringAsFixed(1)}% від анатомічної норми)";
                          });
                        }
                      },
                      child: const Text("Розрахувати", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredScales = _scales.where((s) {
      final matchesCategory = _selectedCategory == "Всі" || s.category == _selectedCategory;
      final matchesSearch = s.name.toLowerCase().contains(_searchQuery.toLowerCase()) || s.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Клінічні шкали"), backgroundColor: Colors.indigo.shade600, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Пошук шкали чи тесту", prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: ChoiceChip(
                      label: Text(cat, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 11)),
                      selected: isSelected,
                      selectedColor: Colors.indigo.shade600,
                      backgroundColor: Colors.grey.shade200,
                      onSelected: (bool selected) => setState(() => _selectedCategory = cat),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filteredScales.isEmpty
                  ? const Center(child: Text("Тестів не знайдено"))
                  : ListView.builder(
                      itemCount: filteredScales.length,
                      itemBuilder: (context, index) {
                        final scale = filteredScales[index];
                        final isGonio = scale.category == "Інструменти";
                        return Card(
                          elevation: 1,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Icon(isGonio ? Icons.architecture : Icons.assignment_outlined, color: isGonio ? Colors.teal : Colors.indigo.shade400, size: 24),
                            title: Text(scale.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            subtitle: Text(scale.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11)),
                            trailing: const Icon(Icons.play_circle_fill, color: Colors.indigo, size: 24),
                            onTap: () => _openScaleDetail(scale),
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
