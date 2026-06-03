import 'package:intl/intl.dart';

// Модель окремого візиту (сесії реабілітації) пацієнта
class PatientVisit {
  final String id;
  final DateTime date;
  String therapeuticNote;       // Нотатки терапевта щодо поточної сесії
  Map<String, String> testResults; // Тести та шкали, проведені саме під час цього візиту
  List<String> assignedExercises; // Вправи, призначені або виконані під час візиту

  PatientVisit({
    required this.id,
    required this.date,
    this.therapeuticNote = '',
    Map<String, String>? testResults,
    List<String>? assignedExercises,
  }) : this.testResults = testResults ?? {},
       this.assignedExercises = assignedExercises ?? [];
}

// Модель Індивідуального реабілітаційного плану (ІРП) за стандартами МОЗ
class IrpPlan {
  String goalsSmart;          // Реабілітаційні цілі за системою S.M.A.R.T.
  String mfkCodes;            // Коди та категорії МКФ (Міжнародна класифікація функціонування)
  String rehabilitationCycle; // Етап/цикл: Первинний, Повторний, Заключний
  String interventionPlan;    // Загальний план реабілітаційних втручань
  String specialistName;      // ПІБ відповідального фізичного терапевта

  IrpPlan({
    this.goalsSmart = '',
    this.mfkCodes = '',
    this.rehabilitationCycle = 'Первинний',
    this.interventionPlan = '',
    this.specialistName = '',
  });
}

// Повна інтегрована картка пацієнта
class Patient {
  final String id;
  String name;
  String birthDate;
  String diagnosisMkh10; // Код та опис за МКХ-10
  String admissionDate;
  IrpPlan irp;           // Індивідуальний реабілітаційний план
  List<PatientVisit> visits; // Історія кожного візиту пацієнта

  Patient({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.diagnosisMkh10,
    required this.admissionDate,
    required this.irp,
    List<PatientVisit>? visits,
  }) : this.visits = visits ?? [];

  // Функція для збору найсвіжіших результатів усіх шкал
  Map<String, String> getLatestScaleResults() {
    Map<String, String> latestResults = {};
    // Проходимо по всіх візитах від найстарішого до найновішого
    for (var visit in visits) {
      visit.testResults.forEach((scaleName, result) {
        latestResults[scaleName] = result;
      });
    }
    return latestResults;
  }

  // Генерація офіційної медичної виписки згідно з протоколами МОЗ України
  String generateMoxStatement() {
    final DateFormat formatter = DateFormat('dd.MM.yyyy HH:mm');
    final String currentDate = formatter.format(DateTime.now());
    final Map<String, String> currentScales = getLatestScaleResults();

    String visitsLog = '';
    if (visits.isEmpty) {
      visitsLog = 'Візити не зафіксовані.\n';
    } else {
      for (int i = 0; i < visits.length; i++) {
        final visit = visits[i];
        visitsLog += '\nВізит №${i + 1} (${formatter.format(visit.date)}):\n';
        visitsLog += '  • Статус/Нотатка: ${visit.therapeuticNote.isEmpty ? 'б/н' : visit.therapeuticNote}\n';
        if (visit.testResults.isNotEmpty) {
          visitsLog += '  • Проведені тести: ${visit.testResults.entries.map((e) => '${e.key} (${e.value})').join(', ')}\n';
        }
        if (visit.assignedExercises.isNotEmpty) {
          visitsLog += '  • Виконані вправи: ${visit.assignedExercises.join(', ')}\n';
        }
      }
    }

    return '''
======================================================================
     ВИПИСКА З ІНДИВІДУАЛЬНОГО РЕАБІЛІТАЦІЙНОГО ПЛАНУ ПАЦІЄНТА
           Згідно з вимогами та чинними протоколами МОЗ України
======================================================================
Дата формування документа: $currentDate
Фахівець з реабілітації: ${irp.specialistName.isEmpty ? 'Не вказано' : irp.specialistName}

1. ЗАГАЛЬНІ ДАНІ ПРО ПАЦІЄНТА:
   ПІБ Пацієнта: $name
   Дата народження: $birthDate
   Дата початку реабілітації: $admissionDate

2. КЛІНІЧНИЙ ДІАГНОЗ ЗА МКХ-10:
   $diagnosisMkh10

3. ФУНКЦІОНАЛЬНИЙ ДІАГНОЗ ТА ОЦІНКА ЗА МКФ:
   ${irp.mfkCodes.isEmpty ? 'Категорії та коди МКФ не визначені.' : irp.mfkCodes}

4. КЛІНІЧНИЙ СТАТУС НА МОМЕНТ ФОРМУВАННЯ ВИПИСКИ (ОСТАННІ ШКАЛИ):
${currentScales.isEmpty ? '   Стандартизоване тестування за шкалами не проводилось.' : currentScales.entries.map((e) => '   • ${e.key}: ${e.value}').join('\n')}

5. РЕАБІЛІТАЦІЙНИЙ ЦИКЛ:
   Поточний етап: ${irp.rehabilitationCycle}

6. СФОРМУЛЬОВАНІ ЦІЛІ РЕАБІЛІТАЦІЇ (ЗА СИСТЕМОЮ S.M.A.R.T.):
   ${irp.goalsSmart.isEmpty ? 'Цілі не встановлено.' : irp.goalsSmart}

7. ПРОГРАМА РЕАБІЛІТАЦІЙНИХ ВТРУЧАНЬ ТА ПРИЗНАЧЕНІ ВПРАВИ:
   ${irp.interventionPlan.isEmpty ? 'Загальний план втручань відсутній.' : irp.interventionPlan}

8. ЖУРНАЛ ОБЛІКУ ВІЗИТІВ ТА ДИНАМІКИ ПАЦІЄНТА:
$visitsLog
======================================================================
Документ є офіційним витягом з карти реабілітації пацієнта.
Створено автоматично в спеціалізованому ПЗ для фізичних терапевтів.
======================================================================
''';
  }
}

// Капітальний клінічний довідник МКХ-10 для фізичної та реабілітаційної медицини
class Mkh10Data {
  static const Map<String, String> commonCodes = {
    // НЕВРОЛОГІЯ ТА НЕЙРОРЕАБІЛІТАЦІЯ (СУДИННІ, ДЕГЕНЕРАТИВНІ)
    'I60': 'Субарахноїдальний крововилів',
    'I61': 'Внутрішньочерепний крововилив (Геморагічний інсульт)',
    'I63': 'Інфаркт мозку (Ішемічний інсульт)',
    'I64': 'Інсульт, не уточнений як крововилив чи інфаркт',
    'I69.0': 'Наслідки субарахноїдального крововиливу',
    'I69.3': 'Наслідки інфаркту мозку (Постінсультний геміпарез/афазія)',
    'G81.0': 'В\'яла геміплегія (В\'ялий парез кінцівок)',
    'G81.1': 'Спастична геміплегія (Спастичний центральний парез кінцівок)',
    'G82.0': 'В\'яла параплегія (Нижній м\'який парез обох ніг)',
    'G82.1': 'Спастична параплегія (Нижній спастичний парез обох ніг)',
    'G82.4': 'Спастична тетраплегія (Парез чотирьох кінцівок)',
    'G20': 'Хвороба Паркінсона',
    'G35': 'Розсіяний склероз',
    'G51.0': 'Парез Белла (Ураження лицевого нерва)',
    'G54.0': 'Ураження плечового сплетіння (Плексит)',
    'G57.3': 'Ураження малогомілкового нерва (Синдром звисаючої стопи)',

    // ТРАВМИ ОПОРНО-РУХОВОГО АПАРАТУ ТА ЦНС
    'T90.5': 'Наслідки внутрішньочерепної травми (Після важких ЧМТ)',
    'T91.1': 'Наслідки перелому хребта (Травма спинного мозку, мієлопатія)',
    'S12': 'Перелом шийного відділу хребта',
    'S22': 'Перелом грудного відділу хребта',
    'S32': 'Перелом попереково-крижового відділу хребта та кісток тазу',
    'S42.2': 'Перелом проксимального кінця плечової кістки',
    'S42.3': 'Перелом тіла [діафіза] плечової кістки',
    'S52': 'Перелом кісток передпліччя (ліктьової чи променевої)',
    'S72.0': 'Перелом шийки стегнової кістки',
    'S72.3': 'Перелом тіла [діафіза] стегнової кістки',
    'S82': 'Перелом кісток гомілки (включаючи кісточки)',

    // ОРТОПЕДІЯ, СУГЛОБИ ТА ХРОНІЧНИЙ БІЛЬ
    'M16': 'Коксартроз (Артроз кульшового суглоба)',
    'M17': 'Гонартроз (Артроз колінного суглоба)',
    'M24.5': 'Контрактура суглоба (Післятривала іммобілізація)',
    'M50': 'Ураження міжхребцевих дисків шийного відділу з радикулопатією',
    'M51.1': 'Ураження міжхребцевих дисків поперекового відділу з радикулопатією',
    'M54.5': 'Біль у нижній частині спини (Хронічний вертеброгенний люмбаго)',
    'M75.0': 'Адгезивний капсуліт плеча (Синдром замороженого плеча)',
  };
}
