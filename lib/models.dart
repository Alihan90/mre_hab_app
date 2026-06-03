// Модель структури Індивідуального реабілітаційного плану (ІРП)
class IrpPlan {
  String goalsSmart;      // Цілі за системою SMART
  String mfkCodes;         // Коди МКФ (Міжнародна класифікація функціонування)
  String rehabilitationCycle; // Етап/цикл реабілітації
  String interventionPlan;  // План втручань (вправи, періодичність)
  String SpecialistName;   // Відповідальний фіз. терапевт

  IrpPlan({
    this.goalsSmart = '',
    this.mfkCodes = '',
    this.rehabilitationCycle = 'Первинний',
    this.interventionPlan = '',
    this.SpecialistName = '',
  });
}

// Повна картка пацієнта з інтегрованою медичною документацією
class Patient {
  final String id;
  String name;
  String birthDate;
  String diagnosisMkh10; // Код та опис МКХ-10
  String admissionDate;
  Map<String, String> scaleResults; // Всі 16 клінічних шкал
  IrpPlan irp;                     // Індивідуальний реабілітаційний план

  Patient({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.diagnosisMkh10,
    required this.admissionDate,
    required this.scaleResults,
    required this.irp,
  });

  // Функція для генерації офіційного тексту виписки за вимогами МОЗ України
  String generateMoxStatement() {
    return '''
==================================================
ВИПИСКА З ІНДИВІДУАЛЬНОГО РЕАБІЛІТАЦІЙНОГО ПЛАНУ
Згідно з протоколами МОЗ України та засадами МКФ
==================================================
Пацієнт: $name
Дата народження: $birthDate
Дата госпіталізації/прийому: $admissionDate
Відповідальний терапевт: ${irp.SpecialistName.isEmpty ? 'Не вказано' : irp.SpecialistName}

КЛІНІЧНИЙ ДІАГНОЗ (МКХ-10):
$diagnosisMkh10

ОЦІНКА ЗА МІЖНАРОДНОЮ КЛАСИФІКАЦІЄЮ ФУНКЦІОНУВАННЯ (МКФ):
${irp.mfkCodes.isEmpty ? 'Дані відсутні' : irp.mfkCodes}

РЕЗУЛЬТАТИ СТАНДАРТИЗОВАНОГО ТЕСТУВАННЯ ТА ШКАЛ:
${scaleResults.isEmpty ? 'Шкали не застосовувались' : scaleResults.entries.map((e) => '• ${e.key}: ${e.value}').join('\n')}

РЕАБІЛІТАЦІЙНИЙ ЦИКЛ: ${irp.rehabilitationCycle}

ЦІЛІ РЕАБІЛІТАЦІЇ ЗА СИСТЕМОЮ S.M.A.R.T.:
${irp.goalsSmart.isEmpty ? 'Цілі не сформульовано' : irp.goalsSmart}

ПЛАН РЕАБІЛІТАЦІЙНИХ ВТРУЧАНЬ ТА ФІЗИЧНИХ ВПРАВ:
${irp.interventionPlan.isEmpty ? 'Програма вправ не розписана' : irp.interventionPlan}

--------------------------------------------------
Документ сформовано автоматично в додатку реабілітації.
Дата вивантаження: ${DateTime.now().toString().split(' ')[0]}
==================================================
''';
  }
}

// Статична база даних МКХ-10 для швидкого вибору
class Mkh10Data {
  static const Map<String, String> commonCodes = {
    'I61': 'Внутрішньочерепний крововилив (Геморагічний інсульт)',
    'I63': 'Інфаркт мозку (Ішемічний інсульт)',
    'G81': 'Геміплегія (Парез кінцівок)',
    'T90': 'Наслідки травми голови (ЧМТ)',
    'M50': 'Ураження міжхребцевих дисків шийного відділу з радикулопатією',
    'M51': 'Ураження міжхребцевих дисків інших відділів',
    'G04': 'Енцефаліт, мієліт та енцефаломієліт',
    'S42': 'Перелом плечової кістки',
    'S72': 'Перелом стегнової кістки (в т.ч. шийки стегна)',
  };
}
