import 'package:flutter/material.dart';

// Модель даних для структурованої вправи
class RehabilitationExercise {
  final String name;
  final String category;
  final String targetMuscles;
  final String purpose;
  final String instruction;
  final String dosage;

  const RehabilitationExercise({
    required this.name,
    required this.category,
    required this.targetMuscles,
    required this.purpose,
    required this.instruction,
    required this.dosage,
  });
}

class ExercisesScreen extends StatefulWidget {
  final Function(String)? onSelectExercise; // Для майбутнього зв'язку з карткою пацієнта

  const ExercisesScreen({super.key, this.onSelectExercise});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  // Величезна клінічна база даних вправ без скорочень
  final List<RehabilitationExercise> _allExercises = const [
    // --- БЛОК 1: РАННЯ МОБІЛІЗАЦІЯ ---
    RehabilitationExercise(
      name: 'Пасивні рухи в суглобах кінцівок (Груба розробка)',
      category: 'Рання мобілізація (Постільний режим)',
      targetMuscles: 'Усі великі суглоби (плечовий, ліктьовий, кульшовий, колінний)',
      purpose: 'Профілактика ранніх суглобових контрактур, покращення лімфотоку, стимуляція пропріоцепції у паретичних кінцівках.',
      instruction: 'Терапевт плавно, без ривків виконує рухи у суглобі пацієнта (згинання, розгинання, відведення) до фізіологічної межі або появи першого опору/болю. Фіксація проксимального сегмента обов\'язкова.',
      dosage: '3 підходи по 10-15 повторень для кожного суглоба, 2 рази на добу.',
    ),
    RehabilitationExercise(
      name: 'Дихальна гімнастика (Дренажні техніки)',
      category: 'Рання мобілізація (Постільний режим)',
      targetMuscles: 'Діафрагма, міжреберні м\'язи',
      purpose: 'Профілактика гіпостатичної пневмонії у лежачих пацієнтів, активація екскурсії грудної клітки.',
      instruction: 'Контрольований глибокий вдих через ніс із надуванням живота (діафрагмальне дихання), тривала затримка дихання на 2-3 секунди та повільний видих через складені трубочкою губи.',
      dosage: '5-7 повторень щогодини в активний період доби.',
    ),
    RehabilitationExercise(
      name: 'Активація дельтоподібного м\'яза та ротаторів плеча (Ізометрія)',
      category: 'Рання мобілізація (Постільний режим)',
      targetMuscles: 'm. deltoideus, m. supraspinatus',
      purpose: 'Попередження сублюксації (вивиху) плечового суглоба у пацієнтів з млявим геміпарезом.',
      instruction: 'Пацієнт намагається натиснути ліктем на кушетку або руку терапевта без реального руху в суглобі. Терапевт утримує суглоб у фізіологічно правильному положенні.',
      dosage: 'Утримання напруги 5-6 секунд, відпочинок 10 секунд. Повторити 8-10 разів.',
    ),

    // --- БЛОК 2: ВЕРТИКАЛІЗАЦІЯ ---
    RehabilitationExercise(
      name: 'Ортостатичне тренування на поворотній кушетці (Тілт-стіл)',
      category: 'Вертикалізація та ортостаз',
      targetMuscles: 'Серцево-судинна система, стабілізатори тулуба',
      purpose: 'Адаптація судинного русла до вертикального положення, профілактика ортостатичного колапсу (запаморочення, втрати свідомості).',
      instruction: 'Пацієнт фіксується ременями на столі. Кут підйому збільшується поступово: 30° -> 45° -> 60° -> 80°. Обов\'язково контролюється АТ та пульс кожні 3 хвилини.',
      dosage: 'Експозиція від 10 до 30 хвилин залежно від стабільності гемодинаміки.',
    ),
    RehabilitationExercise(
      name: 'Перехід у положення сидячи з опущеними ногами',
      category: 'Вертикалізація та ортостаз',
      targetMuscles: 'М\'язи кору, випрямлячі хребта',
      purpose: 'Транзиторний етап вертикалізації, тренування статичного балансу в положенні сидячи.',
      instruction: 'Терапевт допомагає пацієнту повернутися на бік, акуратно спускає ноги з кушетки та підіймає плечовий пояс. Пацієнт утримує рівновагу з опорою (або без неї) руками за край кушетки.',
      dosage: 'Тривалість сидіння від 5 до 20 хвилин, 2-3 рази на день.',
    ),
    RehabilitationExercise(
      name: 'Вправа "Сісти-Встати" (Squat-to-Stand) з опорою',
      category: 'Вертикалізація та ортостаз',
      targetMuscles: 'm. quadriceps femoris, m. gluteus maximus',
      purpose: 'Відновлення сили ніг, підготовка до локомоції (ходьби), тренування динамічного перенесення ваги.',
      instruction: 'Пацієнт сидить на стільці, стопи щільно на підлозі. Тримаючись за бруси або поручні, зміщує центр ваги вперед і за рахунок зусилля м\'язів стегон повністю випрямляє тулуб.',
      dosage: '2-3 підходи по 8-12 повторень з відпочинком між підходами по 2 хвилини.',
    ),

    // --- БЛОК 3: ВЕРХНІ КІНЦІВКИ ---
    RehabilitationExercise(
      name: 'Розробка дрібної моторики кисті (Циліндричне захоплення)',
      category: 'Верхні кінцівки (Дрібна моторика)',
      targetMuscles: 'Згиначі та розгиначі пальців, міжкісткові м\'язи кисті',
      purpose: 'Відновлення хапальної функції кисті, стимуляція коркових представництв у ПМЗ.',
      instruction: 'Пацієнт бере предмети різного діаметра (циліндри, м\'ячі, кілки), стискає їх з максимальним зусиллям протягом 3 секунд і плавно відпускає. Пріоритет на утриманні великого пальця протилежно іншим.',
      dosage: 'Виконувати протягом 10-15 хвилин, чергуючи предмети за формою та текстурою.',
    ),
    RehabilitationExercise(
      name: 'Пронація-Супінація передпліччя з обтяженням (Ерготерапія)',
      category: 'Верхні кінцівки (Координація та сила)',
      targetMuscles: 'm. pronator teres, m. supinator',
      purpose: 'Відновлення побутових рухів (поворот ключа, відкривання дверей).',
      instruction: 'Лікоть зігнутий під кутом 90° і притиснутий до тулуба. Пацієнт тримає в руці терапевтичну палицю або легку гантель і повільно повертає долоню вгору (супінація), а потім вниз (пронація).',
      dosage: '3 підходи по 12 повторень в кожен бік.',
    ),

    // --- БЛОК 4: НИЖНІ КІНЦІВКИ ТА БАЛАНС ---
    RehabilitationExercise(
      name: 'Степ-даун (Сходження з платформи) на контроль коліна',
      category: 'Нижні кінцівки та Баланс',
      targetMuscles: 'm. quadriceps, m. gluteus medius (стабілізатор тазу)',
      purpose: 'Усунення рекурвації (перерозгинання) колінного суглоба під час ходьби, тренування ексцентричного контролю.',
      instruction: 'Пацієнт стоїть здоровою ногою на невисокій платформі (степ), а уражену ногу повільно спускає вниз, злегка торкаючись п\'ятою підлоги, після чого за рахунок опорної ноги повертається у вихідне положення.',
      dosage: '3 підходи по 10 повторень контрольованого повільного руху.',
    ),
    RehabilitationExercise(
      name: 'Балансування на балансувальній подушці (Пропріоцепція)',
      category: 'Нижні кінцівки та Баланс',
      targetMuscles: 'М\'язи-стабілізатори гомілковостопного суглоба, глибокі м\'язи хребта',
      purpose: 'Відновлення реакцій рівноваги, захист від падінь, покращення стійкості при ходьбі по нерівній поверхні.',
      instruction: 'Пацієнт стає двома (або однією для просунутих) ногами на нестабільну подушку типу Airex/Bosu. Намагається утримати вертикальну вісь тіла без надмірних коливань тулуба.',
      dosage: 'Стояння по 30-60 секунд, 5 серій з коротким відпочинком.',
    ),
  ];

  String _selectedCategory = 'Усі розділи';
  
  List<String> get _categories => [
    'Усі розділи',
    'Рання мобілізація (Постільний режим)',
    'Вертикалізація та ортостаз',
    'Верхні кінцівки (Дрібна моторика)',
    'Верхні кінцівки (Координація та сила)',
    'Нижні кінцівки та Баланс',
  ];

  @override
  Widget build(BuildContext context) {
    // Фільтрація списку вправ за категорією
    final filteredExercises = _selectedCategory == 'Усі розділи'
        ? _allExercises
        : _allExercises.where((ex) => ex.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Клінічні Комплекси Вправ'),
        backgroundColor: Colors.green.shade100,
      ),
      body: Column(
        children: [
          // Випадаючий список фільтрації категорій
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.green.shade50,
            child: Row(
              children: [
                const Icon(Icons.filter_list, color: Colors.green),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: _categories.map((String cat) {
                      return DropdownMenuItem<String>(
                        value: cat,
                        child: Text(cat, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      );
                    }).toList(),
                    onChanged: (String? newCat) {
                      if (newCat != null) {
                        setState(() {
                          _selectedCategory = newCat;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Список вправ з розгорнутим описом
          Expanded(
            child: ListView.builder(
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                final ex = filteredExercises[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 2,
                  child: ExpansionTile(
                    leading: const Icon(Icons.fitness_center, color: Colors.green),
                    title: Text(ex.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    subtitle: Text('Цільова зона: ${ex.targetMuscles}', style: const TextStyle(fontSize: 13, color: Colors.black54)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoSection('Клінічна мета:', ex.purpose, Colors.blue.shade900),
                            const SizedBox(height: 8),
                            _buildInfoSection('Техніка виконання (Методика):', ex.instruction, Colors.black87),
                            const SizedBox(height: 8),
                            _buildInfoSection('Рекомендоване дозування:', ex.dosage, Colors.red.shade900),
                            
                            // Кнопка призначення пацієнту (для майбутньої логіки)
                            if (widget.onSelectExercise != null) ...[
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 40),
                                ),
                                onPressed: () {
                                  widget.onSelectExercise!(ex.name);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Вправу "${ex.name}" додано до призначень')),
                                  );
                                },
                                icon: const Icon(Icons.add_circle_outline),
                                label: const Text('Призначити поточному пацієнту'),
                              )
                            ]
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
    );
  }

  Widget _buildInfoSection(String title, String content, Color contentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
        const SizedBox(height: 2),
        Text(content, style: TextStyle(fontSize: 14, color: contentColor, height: 1.3)),
      ],
    );
  }
}
