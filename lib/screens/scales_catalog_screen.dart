import 'package:flutter/material.dart';

class ScalesCatalogScreen extends StatefulWidget {
  final Function(String, String)? onScaleTested;

  const ScalesCatalogScreen({super.key, this.onScaleTested});

  @override
  State<ScalesCatalogScreen> createState() => _ScalesCatalogScreenState();
}

class _ScalesCatalogScreenState extends State<ScalesCatalogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Клінічні Оцінювальні Шкали'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _buildScaleTile(
            context,
            'Шкала MRC-SumScore',
            'Оцінка загальної сили м’язів (парези, інсульти)',
            'Визначення сумарної сили 6 м\'язових груп кінцівок від 0 до 60 балів.',
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => MrcScaleTestScreen(onSave: widget.onScaleTested))),
          ),
          _buildScaleTile(
            context,
            'Шкала балансу Берга (Berg Balance Scale)',
            'Оцінка ризику падінь та статико-динамічного балансу',
            'Повноцінний тест із 14 функціональних завдань для контролю стійкості пацієнта.',
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => BergBalanceTestScreen(onSave: widget.onScaleTested))),
          ),
          _buildScaleTile(
            context,
            'Індекс мобільності Рівермід (RMI)',
            'Оцінка рівня рухової активності та локомоції',
            'Опитувальник з 15 пунктів (від повертання v ліжку до підйому по сходах).',
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => RivermeadTestScreen(onSave: widget.onScaleTested))),
          ),
          _buildScaleTile(
            context,
            'Модифікована шкала Ашворт (Ashworth)',
            'Оцінка рівня спастичності м\'язового тонусу',
            'Експрес-тест опору м\'язів при пасивному розтягуванні від 0 до 4 балів.',
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => AshworthTestScreen(onSave: widget.onScaleTested))),
          ),
        ],
      ),
    );
  }

  Widget _buildScaleTile(BuildContext context, String title, String subtitle, String desc, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: const Icon(Icons.analytics_outlined, size: 36, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87, fontSize: 13)),
            const SizedBox(height: 4),
            Text(desc, style: const TextStyle(color: Colors.black54, fontSize: 12)),
          ],
        ),
        trailing: const Icon(Icons.play_circle_fill, color: Colors.blue, size: 32),
        onTap: onTap,
      ),
    );
  }
}

class MrcScaleTestScreen extends StatefulWidget {
  final Function(String, String)? onSave;
  const MrcScaleTestScreen({super.key, this.onSave});

  @override
  State<MrcScaleTestScreen> createState() => _MrcScaleTestScreenState();
}

class _MrcScaleTestScreenState extends State<MrcScaleTestScreen> {
  final Map<String, int> _scores = {
    'Відведення плеча (ПРАВА)': 5, 'Відведення плеча (ЛІВА)': 5,
    'Згинання ліктя (ПРАВА)': 5, 'Згинання ліктя (ЛІВА)': 5,
    'Розгинання кисті (ПРАВА)': 5, 'Розгинання кисті (ЛІВА)': 5,
    'Згинання стегна (ПРАВА)': 5, 'Згинання стегна (ЛІВА)': 5,
    'Розгинання коліна (ПРАВА)': 5, 'Розгинання коліна (ЛІВА)': 5,
    'Тильне згинання стопи (ПРАВА)': 5, 'Тильне згинання стопи (ЛІВА)': 5,
  };

  int get _total => _scores.values.fold(0, (sum, val) => sum + val);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Тест: MRC-SumScore')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.blue.shade50,
            child: const Text(
              'Методика: Оцініть силу м\'язів від 0 (немає скорочень) до 5 (нормальна сила проти опору) для кожної групи. Максимум: 60 балів.',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('Загальний результат: $_total / 60 балів', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
          ),
          Expanded(
            child: ListView(
              children: _scores.keys.map((muscle) {
                return ListTile(
                  title: Text(muscle, style: const TextStyle(fontSize: 14)),
                  trailing: DropdownButton<int>(
                    value: _scores[muscle],
                    items: [0, 1, 2, 3, 4, 5].map((v) => DropdownMenuItem(value: v, child: Text('$v балів'))).toList(),
                    onChanged: (val) { if (val != null) setState(() => _scores[muscle] = val); },
                  ),
                );
              }).toList(),
            ),
          ),
          _buildSaveButton(context, 'MRC-SumScore', '$_total/60 балів'),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, String name, String result) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 48)),
        onPressed: () {
          if (widget.onSave != null) widget.onSave!(name, result);
          Navigator.pop(context);
        },
        child: const Text('Зберегти результат тесту у візит', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class BergBalanceTestScreen extends StatefulWidget {
  final Function(String, String)? onSave;
  const BergBalanceTestScreen({super.key, this.onSave});

  @override
  State<BergBalanceTestScreen> createState() => _BergBalanceTestScreenState();
}

class _BergBalanceTestScreenState extends State<BergBalanceTestScreen> {
  final List<int> _answers = List.filled(14, 4);

  final List<String> _tasks = [
    '1. Перехід з положення сидячи в положення стояти',
    '2. Стояння без опори (2 хвилини)',
    '3. Сидіння без опори, стопи на підлозі (2 хвилини)',
    '4. Перехід з положення стоячи v положення сидячи',
    '5. Пересаджування (з крісла на крісло)',
    '6. Стояння із заплющеними очима (10 секунд)',
    '7. Стояння з близько поставленими стопами',
    '8. Нахил вперед із витягнутою рукою',
    '9. Підняття предмета з підлоги',
    '10. Поворот тулуба назад (озирання)',
    '11. Поворот на 360 градусів',
    '12. Почергове закрокування стопами на сходинку',
    '13. Стояння одна нога попереду іншої (Тандем)',
    '14. Стояння на одній нозі (>10 секунд)',
  ];

  int get _total => _answers.fold(0, (sum, val) => sum + val);

  String _getInterpretation() {
    if (_total <= 20) return 'Високий ризик падінь (Пересування у візку)';
    if (_total <= 40) return 'Помірний ризик падінь (Ходьба з допомогою)';
    return 'Низький ризик падінь (Самостійна мобільність)';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Тест: Шкала Берга')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.amber.shade50,
            child: Text(
              'Клінічний висновок: $_total б. — ${_getInterpretation()}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.amber),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, idx) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(_tasks[idx], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
                        DropdownButton<int>(
                          value: _answers[idx],
                          items: [0, 1, 2, 3, 4].map((v) => DropdownMenuItem(value: v, child: Text('$v балів'))).toList(),
                          onChanged: (val) { if (val != null) setState(() => _answers[idx] = val); },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 48)),
              onPressed: () {
                if (widget.onSave != null) widget.onSave!('Шкала Берга', '$_total/56 б. (${_getInterpretation()})');
                Navigator.pop(context);
              },
              child: const Text('Зберегти результат у візит', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class RivermeadTestScreen extends StatefulWidget {
  final Function(String, String)? onSave;
  const RivermeadTestScreen({super.key, this.onSave});

  @override
  State<RivermeadTestScreen> createState() => _RivermeadTestScreenState();
}

class _RivermeadTestScreenState extends State<RivermeadTestScreen> {
  final List<bool> _answers = List.filled(15, false);

  final List<String> _questions = [
    '1. Повертання в ліжку: чи може пацієнт самостійно повернутися з боку на бік?',
    '2. Перехід із положення лежачи v положення сидячи на краю ліжка?',
    '3. Утримання рівноваги v положенні сидячи без опори протягом 10 сек?',
    '4. Перехід з положення сидячи v стояче положення без сторонньої допомоги?',
    '5. Стояння без опори протягом 10 секунд?',
    '6. Пересаджування з ліжка на стілець і назад без допомоги?',
    '7. Ходьба по кімнаті (можна з тростиною) на відстань 10 метрів?',
    '8. Підйом по сходах на один проліт без сторонньої допомоги?',
    '9. Ходьба по вулиці по рівній поверхні на відстань до 50 метров?',
    '10. Ходьба по кімнаті без використання допоміжних засобів опори?',
    '11. Підйом предмета з підлоги без опори на стілець/стіну?',
    '12. Ходьба по вулиці по нерівній поверхні (трава, гравій, бруківка)?',
    '13. Вхід та вихід з ванної/душу самостійно?',
    '14. Підйом на 4 сходинки без перил?',
    '15. Біг або швидке прискорення на 10 метрів без кульгавості?',
  ];

  int get _total => _answers.where((item) => item == true).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Індекс мобільності Рівермід')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.teal.shade50,
            child: Text('Результат локомоції: $_total з 15 балів (1 бал за кожне "Так")', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _questions.length,
              itemBuilder: (context, idx) {
                return CheckboxListTile(
                  title: Text(_questions[idx], style: const TextStyle(fontSize: 13)),
                  value: _answers[idx],
                  onChanged: (val) { if (val != null) setState(() => _answers[idx] = val); },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 48)),
              onPressed: () {
                if (widget.onSave != null) widget.onSave!('Індекс Рівермід', '$_total/15 балів');
                Navigator.pop(context);
              },
              child: const Text('Зберегти результат у візит', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class AshworthTestScreen extends StatefulWidget {
  final Function(String, String)? onSave;
  const AshworthTestScreen({super.key, this.onSave});

  @override
  State<AshworthTestScreen> createState() => _AshworthTestScreenState();
}

class _AshworthTestScreenState extends State<AshworthTestScreen> {
  String _selectedGrade = '0';
  
  final Map<String, String> _grades = {
    '0': '0 балів — Немає підвищення тонусу м\'язів при пасивному русі',
    '1': '1 бал — Легке підвищення тонусу (напруга при флексії/екстензії)',
    '1+': '1+ бал — Незначне підвищення тонусу, опір протягом меншої половини ROM',
    '2': '2 бали — Помірне підвищення тонусу м\'язів протягом усього руху ROM',
    '3': '3 бали — Значне підвищення тонусу, пасивний рух утруднений',
    '4': '4 бали — Уражений сегмент кінцівки повністю ригідний (флексія/екстензія неможливі)',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Шкала тонусу Ашворт')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        key: const ValueKey('ashworth_root_view'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Методичне керівництво:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Виконайте швидке пасивне розтягування м\'яза пацієнта (наприклад, розгинання передпліччя або гомілки) і оцініть механічний опір тканин кінцівки.', style: TextStyle(fontSize: 13, color: Colors.black87)),
            const Divider(height: 32),
            Expanded(
              child: ListView(
                children: _grades.entries.map((entry) {
                  return RadioListTile<String>(
                    title: Text(entry.value, style: const TextStyle(fontSize: 14)),
                    value: entry.key,
                    groupValue: _selectedGrade,
                    onChanged: (val) { if (val != null) setState(() => _selectedGrade = val); },
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 48)),
              onPressed: () {
                if (widget.onSave != null) widget.onSave!('Шкала Ашворт', 'Бал: $_selectedGrade');
                Navigator.pop(context);
              },
              child: const Text('Зберегти результат у візит', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
