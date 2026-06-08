// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// ==========================================
// СТРУКТУРА ДАНИХ ДЛЯ МЕДИЧНОЇ КАРТИ ПАЦІЄНТА
// ==========================================
class PatientCard {
  final String id;
  final String fullName;
  final String birthDate;
  final String primaryDiagnosis;
  List<String> smartGoals; // База для Кроку 3 (Конструктор SMART)
  List<String> icdCodes;   // База для Кроку 4 (Довідник МКХ-10)

  PatientCard({
    required this.id,
    required this.fullName,
    required this.birthDate,
    required this.primaryDiagnosis,
    this.smartGoals = const [],
    this.icdCodes = const [],
  });
}

// ==========================================
// МОДУЛЬ: КЛІНІЧНІ ШКАЛИ ТА ГОНІОМЕТРІЯ (СТРУКТУРОВАНИЙ)
// ==========================================
class ClinicalScale {
  final String name;
  final String category; // Нозологічна або вікова група
  final String description;
  final String instruction;
  final String interpretation;

  ClinicalScale({
    required this.name,
    required this.category,
    required this.description,
    required this.instruction,
    required this.interpretation,
  });
}

class ScalesCatalogScreen extends StatefulWidget {
  const ScalesCatalogScreen({Key? key}) : super(key: key);

  @override
  State<ScalesCatalogScreen> createState() => _ScalesCatalogScreenState();
}

class _ScalesCatalogScreenState extends State<ScalesCatalogScreen> {
  String _searchQuery = "";
  String _selectedCategory = "Всі";

  // Клінічні та вікові категорії
  final List<String> _categories = [
    "Всі",
    "Неврологія (дорослі)",
    "Ортопедія та Травматологія",
    "Кардіо-респіраторна",
    "Загальнофункціональні",
    "Pediatria (Дитячі вікові)",
    "Інструменти"
  ];

  // Повна структурована база клінічних шкал
  final List<ClinicalScale> _scales = [
    // --- НЕВРОЛОГІЯ ---
    ClinicalScale(
      name: "Модифікована шкала спастичності Ашворт (MAS)",
      category: "Неврологія (дорослі)",
      description: "Оцінка м'язового тонусу при дослідженні пасивних рухів у хворих з ураженням ЦНС.",
      instruction: "Проведіть пасивне zгинання/розгинання кінцівки у швидкому темпі. Оцініть опір.",
      interpretation: "0: Тонус не підвищений\n1: Легке підвищення (наприкінці руху)\n1+: Легке підвищення (менше половини амплітуди)\n2: Помірне підвищення тонусу, але рух легкий\n3: Значне підвищення тонусу, пасивний рух ускладнений\n4: Уражена частина ригідна (нерухома)",
    ),
    ClinicalScale(
      name: "Шкала інсульту Національного інституту здоров'я (NIHSS)",
      category: "Неврологія (дорослі)",
      description: "Клінічна оцінка тяжкості неврологічного дефіциту у пацієнтів з інсультом.",
      instruction: "Оцініть за чергою 11 параметрів: свідомість, погляд, поля зору, парез обличчя, сила рук/ніг, атаксія, чутливість, мова, дизартрія, ігнорування.",
      interpretation: "0-4 балів: Легкий ступінь інсульту\n5-15 балів: Помірний інсульт\n16-20 балів: Середньо-важкий інсульт\n21-42 балів: Важкий інсульт",
    ),
    ClinicalScale(
      name: "Модифікована шкала Ренкіна (mRS)",
      category: "Неврологія (дорослі)",
      description: "Оцінка ступеня інвалідизації та загальної незалежності після судинних катастроф.",
      instruction: "Шляхом опитування виявіть рівень обмеження повсякденної активності.",
      interpretation: "0: Немає симптомів\n1: Є симптоми, але без обмежень\n2: Легка інвалідність (самообслуговування збережене)\n3: Помірна інвалідність (потрібна допомога, але ходить самостійно)\n4: Важка інвалідність (не ходить без допомоги)\n5: Дуже важка інвалідність (прикутий до ліжка)\n6: Смерть",
    ),
    ClinicalScale(
      name: "Тест оцінки функції руки Френчай (Frenchay Arm Test)",
      category: "Неврологія (дорослі)",
      description: "Оцінка проксимальної та дистальної функції паретичної верхньої кінцівки.",
      instruction: "Запропонуйте пацієнту виконати 5 побутових завдань (стабілізувати лінійку, взяти склянку, піднести руку до голови тощо). Кожен успіх — 1 бал.",
      interpretation: "0 балів: Рука повністю нефункціональна\n5 балів: Повна функція руки",
    ),
    ClinicalScale(
      name: "Шкала коми Глазго (GCS)",
      category: "Неврологія (дорослі)",
      description: "Оцінка ступеня пригнічення свідомості та глибини коми (напр., при ЧМТ).",
      instruction: "Сумуйте бали за трьома тестами: розплющування очей (1-4), мовна реакція (1-5), рухова реакція (1-6).",
      interpretation: "15 балів: Ясна свідомість\n13-14 балів: Оглушення\n9-12 балів: Сопор\n3-8 балів: Кома (8 і менше — критичний стан)",
    ),

    // --- ОРТОПЕДІЯ ---
    ClinicalScale(
      name: "Індекс життєдіяльності Освестрі (ODI)",
      category: "Ортопедія та Травматологія",
      description: "Оцінка впливу больового синдрому в попереку (дорсалгії) на повсякденне життя.",
      instruction: "Оцініть 10 секцій життєдіяльності (інтенсивність болю, сон, ходьба, стояння, подорожі тощо) від 0 до 5 балів.",
      interpretation: "0-20%: Мінімальне обмеження функцій\n21-40%: Помірне обмеження\n41-60%: Важке обмеження функцій\n61-80%: Критичне порушення (інвалідність)\n81-100%: Повна залежність / симуляція",
    ),
    ClinicalScale(
      name: "Візуально-аналогова шкала болю (VAS / ЧРШ)",
      category: "Ортопедія та Травматологія",
      description: "Суб'єктивний метод експрес-оцінки інтенсивності болю пацієнтом.",
      instruction: "Запропонуйте пацієнту обрати цифрове значення від 0 (немає болю) до 10 (нестерпний біль).",
      interpretation: "1-3 бали: Слабкий біль\n4-6 балів: Помірний біль\n7-10 балів: Сильний / критичний біль",
    ),
    ClinicalScale(
      name: "Мануальне м'язове тестування (MMT за Ловеттом)",
      category: "Ортопедія та Травматологія",
      description: "Оцінка сили та витривалості окремих м'язових груп.",
      instruction: "Протестуйте ізольований рух м'яза проти сили тяжіння та проти ручного супротиву терапевта.",
      interpretation: "0: Скорочення немає\n1: Пальпується «слід» скорочення\n2: Рух у повній амплітуді БЕЗ сили тяжіння\n3: Рух проти сили тяжіння\n4: Рух проти сили тяжіння та помірного опору\n5: Нормальна м'язова сила",
    ),

    // --- КАРДІО ---
    ClinicalScale(
      name: "Тест 6-хвилинної ходьби (6MWT)",
      category: "Кардіо-респіраторна",
      description: "Оцінка толерантності до фізичних навантажень та кардіореспіраторної системи.",
      instruction: "Виміряйте максимальну відстань (у метрах), яку пацієнт пройде по прямій траєкторії за 6 хвилин у комфортному темпі.",
      interpretation: "Результат оцінюється індивідуально. Зниження від норми відображає динаміку серцевої або легеневої недостатності.",
    ),

    // --- ЗАГАЛЬНОФУНКЦІОНАЛЬНІ ---
    ClinicalScale(
      name: "Індекс активності повсякденного життя Бартел (Barthel Index)",
      category: "Загальнофункціональні",
      description: "Стандарт оцінки базової самостійності та життєдіяльності пацієнта в стаціонарі.",
      instruction: "Оцініть 10 пунктів самообслуговування та переміщення.",
      interpretation: "0-20 б: Повна залежність\n21-60 б: Тяжка залежність\n61-90 б: Помірна залежність\n91-99 б: Легка залежність\n100 б: Повна незалежність",
    ),
    ClinicalScale(
      name: "Шкала рівноваги Берга (Berg Balance Scale)",
      category: "Загальнофункціональні",
      description: "Комплексний тест статичної та динамічної рівноваги, визначення ризику падінь.",
      instruction: "Попросіть пацієнта виконати 14 рухових завдань (стояння, вставання, нахили, повороти). Оцінка кожного від 0 до 4.",
      interpretation: "0-20 балів: Високий ризик падінь\n21-40 балів: Середній ризик падінь\n41-56 балів: Низький ризик, безпечна ходьба",
    ),
    ClinicalScale(
      name: "Індекс мобільності Рівермід (RMI)",
      category: "Загальнофункціональні",
      description: "Скринінг мобільності від базових поворотів у ліжку до бігу.",
      instruction: "Оцініть 15 дій (14 опитування, 1 пряме спостереження стояння). За кожне «Так» — 1 бал.",
      interpretation: "0 балів: Повна нерухомість\n15 балів: Максимальна функціональна мобільність",
    ),
    ClinicalScale(
      name: "Тест «Встань та йди» (Timed Up and Go - TUG)",
      category: "Загальнофункціональні",
      description: "Швидкий функціональний тест мобільності та динамічного балансу.",
      instruction: "Засічіть час, за який пацієнт встане зі стільця, пройде 3 метри, розвернеться і знову сяде.",
      interpretation: "< 10 сек: Повна норма\n11-20 сек: Початкові порушення мобільності\n> 20 сек: Виражені порушення, високий ризик падінь",
    ),
    ClinicalScale(
      name: "Тест кубиків у коробці (Box and Block Test)",
      category: "Загальнофункціональні",
      description: "Оцінка грубої мануальної спритності та швидкості координації рук.",
      instruction: "Підрахуйте кількість кубиків, перенесених по одному через перегородку коробки за 60 секунд.",
      interpretation: "Показники порівнюють із віковими нормами та здоровою кінцівкою.",
    ),
    ClinicalScale(
      name: "Функціональні категорії ходьби (FAC)",
      category: "Загальнофункціональні",
      description: "Класифікація рівня незалежності при ходьбі та потреби у фізичній підтримці.",
      instruction: "Визначте ступінь участі рук терапевта при страховці ходьби пацієнта на 3 метрах.",
      interpretation: "0: Не ходить\n1: Потрібна безперервна підтримка 2 осіб\n2: Підтримка 1 особи\n3: Тільки нагляд/команди\n4: Ходить сам лише по рівному\n5: Повна незалежність скрізь",
    ),
    ClinicalScale(
      name: "Динамічний індекс ходьби (DGI)",
      category: "Загальнофункціональні",
      description: "Дослідження здатності пацієнта адаптувати ходьбу до складних зовнішніх умов.",
      instruction: "Оцініть 8 завдань (зміна швидкості, повороти голови під час руху, обходження перешкод, сходи).",
      interpretation: "< 19 балів із 24: Висока ймовірність падінь під час ходьби",
    ),

    // --- ПЕДІАТРІЯ ---
    ClinicalScale(
      name: "Велика моторна функція (GMFM-88 / GMFM-66)",
      category: "Pediatria (Дитячі вікові)",
      description: "Стандартизований тест оцінки змін великої моторики у дітей з ДЦП та руховими затримками.",
      instruction: "Проведіть тестування у 5 блоках: А (лежання та повороти), В (сидіння), С (повзання та на колінах), D (стояння), Е (ходьба, біг, стрибки).",
      interpretation: "Розраховується відсотковий показник виконання завдань для кожного вікового рівня відповідно до критеріїв GMFCS.",
    ),
    ClinicalScale(
      name: "Шкала моторного розвитку немовлят Альберти (AIMS)",
      category: "Pediatria (Дитячі вікові)",
      description: "Оцінка моторного дозрівання малюків від народження до самостійної ходьби (0-18 місяців).",
      instruction: "Спостерігайте за спонтанною руховою активністю дитини в 4 положеннях: на животі, на спині, сидячи та стоячи.",
      interpretation: "Бали наносяться на віковий перцентильний графік. Показник нижче 5-го перцентиля вказує на затримку розвитку.",
    ),
    ClinicalScale(
      name: "Тест розвитку зорово-моторної інтеграції Ерхардта (EDVA)",
      category: "Pediatria (Дитячі вікові)",
      description: "Оцінка специфічних компонентів рухів рук та зорово-моторної координації у дітей із порушеннями розвитку.",
      instruction: "Перевірте мимовільні та довільні реакції: фіксація погляду, простежування, захоплення та маніпуляції з предметами.",
      interpretation: "Визначається відповідність функцій верхньої кінцівки та зорового гнозису календарному віку дитини.",
    ),

    // --- ІНСТРУМЕНТИ ---
    ClinicalScale(
      name: "📐 Інструмент: Гоніометрія (Суглобовий статус за ROM)",
      category: "Інструменти",
      description: "Калькулятор дефіциту амплітуди активних та пасивних рухів у суглобах кінцівок.",
      instruction: "Введіть стандартну анатомічну норму для обраного руху та фактичний показник кута, отриманий механічним гоніометром.",
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
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20, left: 16, right: 16,
        ),
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
              Text(scale.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
              const Divider(),
              const Text("📋 Опис:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(scale.description),
              const SizedBox(height: 10),
              const Text("🚀 Методика проведення:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(scale.instruction),
              const SizedBox(height: 10),
              const Text("🔍 Інтерпретація результатів:", style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
                child: Text(scale.interpretation, style: const TextStyle(fontSize: 13, fontFamily: 'Courier')),
              ),
              const SizedBox(height: 15),
              const Text("🔢 Фіксація балів:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: scoreController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Сумарний бал або результат",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                    onPressed: () {
                      if (scoreController.text.isNotEmpty) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Результат (${scoreController.text}) успішно зафіксовано")),
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
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20, left: 16, right: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("📐 Калькулятор гоніометрії (ROM)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
              const Divider(),
              const Text("Введіть нормальну анатомічну амплітуду суглоба та фактично виміряний кут руху:"),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: normController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Анатомічна норма (°)", border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: factController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Кут пацієнта (°)", border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              if (resultString.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.red.shade200)),
                  child: Text(resultString, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Закрити", style: TextStyle(color: Colors.white)),
                    ),
                  ),
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
                            resultString = "Дефіцит амплітуди рухів:\n🔻 ${deficitDeg.toStringAsFixed(1)}° (${deficitPct.toStringAsFixed(1)}% від фізіологічної норми)";
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
      final matchesSearch = s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            s.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Клінічні шкали за групами"),
        backgroundColor: Colors.indigo.shade600,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Швидкий пошук шкали чи тесту",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
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
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(cat, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 12)),
                      selected: isSelected,
                      selectedColor: Colors.indigo.shade600,
                      backgroundColor: Colors.grey.shade200,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filteredScales.isEmpty
                  ? const Center(child: Text("Тестів у цій групі не знайдено"))
                  : ListView.builder(
                      itemCount: filteredScales.length,
                      itemBuilder: (context, index) {
                        final scale = filteredScales[index];
                        final isGonio = scale.category == "Інструменти";
                        return Card(
                          elevation: 1.5,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: Icon(
                              isGonio ? Icons.architecture : Icons.category_outlined,
                              color: isGonio ? Colors.teal : Colors.indigo.shade400,
                              size: 26,
                            ),
                            title: Text(scale.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(scale.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11.5)),
                            ),
                            trailing: const Icon(Icons.play_circle_fill, color: Colors.indigo, size: 26),
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

// ==========================================
// ДРУГОРЯДНІ СЕКЦІЇ (БУДУТЬ ОНОВЛЮВАТИСЬ ДАЛІ)
// ==========================================
class ExercisesCatalogView extends StatelessWidget {
  const ExercisesCatalogView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Вправи та ЛФК")));
}

// Головна точка входу
void main() {
  runApp(const RehabilitationApp());
}

class RehabilitationApp extends StatelessWidget {
  const RehabilitationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MReHab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('uk', 'UA'),
        Locale('en', 'US'),
      ],
      home: const MainDashboardScreen(),
    );
  }
}

// ==========================================
// 1. ГОЛОВНИЙ ЕКРАН — РОБОЧИЙ СТІЛ (6 ПЛИТОК)
// ==========================================
class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({Key? key}) : super(key: key);

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  final List<PatientCard> _globalPatients = [
    PatientCard(
      id: "1",
      fullName: "Іваненко Петро Миколайович",
      birthDate: "15.05.1978",
      primaryDiagnosis: "Наслідки ішемічного інсульту, лівобічний геміпарез",
      smartGoals: ["Збільшити кут згинання у ліктьовому суглобі до 90° за 3 тижні"],
      icdCodes: ["I69.3"],
    ),
    PatientCard(
      id: "2",
      fullName: "Сидоренко Ольга Володимирівна",
      birthDate: "22.11.1990",
      primaryDiagnosis: "Компресійний перелом L1 хребця, стан після металоостеосинтезу",
      smartGoals: ["Ходьба без опори на відстань до 100м без болю за 14 днів"],
      icdCodes: ["S32.0"],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MReHab — Робочий стіл",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              "Оберіть необхідний клінічний інструмент:",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                children: [
                  _buildDashboardCard(
                    context,
                    title: "Пацієнти",
                    subtitle: "База та Журнал карт",
                    icon: Icons.people,
                    color: Colors.blue.shade600,
                    destination: PatientsScreen(
                      patients: _globalPatients,
                      onPatientsUpdated: () => setState(() {}),
                    ),
                  ),
                  _buildDashboardCard(
                    context,
                    title: "Клінічні шкали",
                    subtitle: "16 тестів та Гоніометрія",
                    icon: Icons.assignment,
                    color: Colors.indigo.shade600,
                    destination: const ScalesCatalogScreen(),
                  ),
                  _buildDashboardCard(
                    context,
                    title: "Конструктор цілей",
                    subtitle: "SMART критерії",
                    icon: Icons.track_changes,
                    color: Colors.green.shade600,
                    destination: const EmbeddedSmartGoalsScreen(),
                  ),
                  _buildDashboardCard(
                    context,
                    title: "МКХ-10 / МКФ",
                    subtitle: "Діагностичні коди",
                    icon: Icons.assignment_turned_in,
                    color: Colors.amber.shade700,
                    destination: const EmbeddedIcdScreen(),
                  ),
                  _buildDashboardCard(
                    context,
                    title: "Вправи та ЛФК",
                    subtitle: "Протоколи занять",
                    icon: Icons.fitness_center,
                    color: Colors.purple.shade600,
                    destination: const ExercisesCatalogView(),
                  ),
                  _buildDashboardCard(
                    context,
                    title: "Налаштування",
                    subtitle: "Профіль терапевта",
                    icon: Icons.settings,
                    color: Colors.teal.shade600,
                    destination: null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget? destination,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          if (destination != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Модуль налаштовується")),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, size: 32, color: color),
              ),
              const Spacer(),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, height: 1.2)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade600, height: 1.2)),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 🛠️ ЕКРАН БАЗИ ПАЦІЄНТІВ
// ==========================================
class PatientsScreen extends StatefulWidget {
  final List<PatientCard> patients;
  final VoidCallback onPatientsUpdated;

  const PatientsScreen({
    Key? key,
    required this.patients,
    required this.onPatientsUpdated,
  }) : super(key: key);

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  String _searchQuery = "";

  void _showAddPatientDialog() {
    final nameController = TextEditingController();
    final dateController = TextEditingController();
    final diagnosisController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Нова карта пацієнта", style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "ПІБ Пацієнта", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: "Дата народження (ДД.ММ.РРРР)", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: diagnosisController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: "Первинний діагноз", border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Скасувати")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700),
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  widget.patients.add(PatientCard(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    fullName: nameController.text,
                    birthDate: dateController.text.isEmpty ? "Не вказано" : dateController.text,
                    primaryDiagnosis: diagnosisController.text.isEmpty ? "Діагноз відсутній" : diagnosisController.text,
                    smartGoals: [],
                    icdCodes: [],
                  ));
                });
                widget.onPatientsUpdated();
                Navigator.pop(context);
              }
            },
            child: const Text("Створити карту", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _openPatientJournal(PatientCard patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Медична карта пацієнта"),
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Card(
                  color: Colors.blue.shade50,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(patient.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                        const SizedBox(height: 5),
                        Text("Дата народження: ${patient.birthDate}", style: const TextStyle(fontSize: 14)),
                        const Divider(),
                        const Text("Клінічний діагноз:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(patient.primaryDiagnosis, style: TextStyle(color: Colors.grey.shade800)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text("📌 Реабілітаційні цілі (SMART)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                patient.smartGoals.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Цілі ще не встановлено. Скористайтеся Конструктором SMART на робочому столі."),
                      )
                    : Column(
                        children: patient.smartGoals.map((goal) => Card(
                          child: ListTile(
                            leading: const Icon(Icons.track_changes, color: Colors.green),
                            title: Text(goal),
                          ),
                        )).toList(),
                      ),
                const SizedBox(height: 20),
                const Text("🗂️ Зареєстровані коди МКХ-10", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                patient.icdCodes.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Коди не додано. Використовуйте довідник МКХ на робочому столі."),
                      )
                    : Wrap(
                        spacing: 8,
                        children: patient.icdCodes.map((code) => Chip(
                          label: Text(code, style: const TextStyle(fontWeight: FontWeight.bold)),
                          backgroundColor: Colors.amber.shade100,
                          avatar: const Icon(Icons.label, size: 16, color: Colors.amber),
                        )).toList(),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredPatients = widget.patients
        .where((p) => p.fullName.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Реєстр пацієнтів"),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      </td>
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Пошук пацієнта за ПІБ",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filteredPatients.isEmpty
                  ? const Center(child: Text("Пацієнтів не знайдено"))
                  : ListView.builder(
                      itemCount: filteredPatients.length,
                      itemBuilder: (context, index) {
                        final patient = filteredPatients[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: Icon(Icons.person, color: Colors.blue.shade700),
                            ),
                            title: Text(patient.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text("Діагноз: ${patient.primaryDiagnosis}", maxLines: 1, overflow: TextOverflow.ellipsis),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () => _openPatientJournal(patient),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPatientDialog,
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }
}

// ==========================================
// 2. ВБУДОВАНИЙ ЕКРАН КОНСТРУКТОРА ЦІЛЕЙ SMART
// ==========================================
class EmbeddedSmartGoalsScreen extends StatefulWidget {
  const EmbeddedSmartGoalsScreen({Key? key}) : super(key: key);

  @override
  State<EmbeddedSmartGoalsScreen> createState() => _EmbeddedSmartGoalsScreenState();
}

class _EmbeddedSmartGoalsScreenState extends State<EmbeddedSmartGoalsScreen> {
  final Map<String, TextEditingController> _controllers = {
    "S": TextEditingController(),
    "M": TextEditingController(),
    "A": TextEditingController(),
    "R": TextEditingController(),
    "T": TextEditingController(),
  };

  final List<Map<String, String>> _fields = [
    {"key": "S", "t": "S - Специфічна (Specific)", "h": "Яку саме функцію відновлюємо?"},
    {"key": "M", "t": "M - Вимірювана (Measurable)", "h": "В яких одиницях (градуси, метри, бали)?"},
    {"key": "A", "t": "A - Досяжна (Achievable)", "h": "Реалістичність з огляду на травму"},
    {"key": "R", "t": "R - Релевантна (Relevant)", "h": "Важливість для повсякденного життя пацієнта"},
    {"key": "T", "t": "T - Обмежена в часі (Time-bound)", "h": "Термін виконання (напр. 2 тижні)"},
  ];

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Конструктор цілей SMART"),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Постановка цілей реабілітації",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _fields.length,
                itemBuilder: (context, index) {
                  final f = _fields[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: _controllers[f["key"]],
                      decoration: InputDecoration(
                        labelText: f["t"],
                        hintText: f["h"],
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600),
                onPressed: () {
                  String finalGoal = _controllers.values.map((c) => c.text).where((text) => text.isNotEmpty).join(" | ");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(finalGoal.isNotEmpty ? "Ціль збережено!" : "Заповніть хоча б одне поле")),
                  );
                },
                child: const Text("Зберегти ціль", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. ВБУДОВАНИЙ ЕКРАН КЛАСИФІКАТОРА МКХ-10
// ==========================================
class EmbeddedIcdScreen extends StatefulWidget {
  const EmbeddedIcdScreen({Key? key}) : super(key: key);

  @override
  State<EmbeddedIcdScreen> createState() => _EmbeddedIcdScreenState();
}

class _EmbeddedIcdScreenState extends State<EmbeddedIcdScreen> {
  final List<Map<String, String>> _icdCodes = [
    {"code": "M50", "name": "Ураження міжхребцевих дисків шийного відділу"},
    {"code": "G80", "name": "Церебральний параліч (ДЦП)"},
    {"code": "I69", "name": "Наслідки цереброваскулярних хвороб (Інсульт)"},
    {"code": "M16", "name": "Коксартроз (артроз кульшового суглоба)"},
    {"code": "S42", "name": "Перелом плечової кістки / суглоба"},
    {"code": "T90", "name": "Наслідки травм голови"},
  ];

  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filtered = _icdCodes
        .where((e) => e["code"]!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                      e["name"]!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Класифікатор МКХ-10 / МКФ"),
        backgroundColor: Colors.amber.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Пошук коду або діагнозу",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Chip(
                        label: Text(filtered[index]["code"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        backgroundColor: Colors.amber.shade100,
                      ),
                      title: Text(filtered[index]["name"]!),
                      trailing: const Icon(Icons.add_circle_outline, color: Colors.amber),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Код ${filtered[index]["code"]} вибрано")),
                        );
                      },
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
