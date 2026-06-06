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
class JointMovementNorm {
  final String jointName;       // Назва суглоба (наприклад, "Плечовий суглоб")
  final String movementType;    // Рух (наприклад, "Згинання", "Розгинання")
  final int normalValue;        // Норма в градусах
  final String instruction;     // Положення пацієнта та орієнтири

  JointMovementNorm({
    required this.jointName,
    required this.movementType,
    required this.normalValue,
    required this.instruction,
  });
}

class GoniometryTestResult {
  final String id;
  final String? patientId;      
  final DateTime date;
  final Map<String, int> measuredValues; // [Суглоб_Рух : Градуси]
  final String notes;           

  GoniometryTestResult({
    required this.id,
    this.patientId,
    required this.date,
    required this.measuredValues,
    required this.notes,
  });
}

class ScaleQuestion {
  final String id;
  final String title;       
  final String description; 
  final List<ScaleOption> options; 

  ScaleQuestion({required this.id, required this.title, required this.description, required this.options});
}

class ScaleOption {
  final int score;         
  final String text;       
  final String? criteria;  

  ScaleOption({required this.score, required this.text, this.criteria});
}

class ScaleInterpretation {
  final int minScore;
  final int maxScore;
  final String resultTitle; 
  final String description; 

  ScaleInterpretation({required this.minScore, required this.maxScore, required this.resultTitle, required this.description});
}

class ClinicalScale {
  final String id;
  final String name;             
  final String fullName;         
  final String category;         
  final String ageGroup;         
  final String instructions;     
  final List<ScaleQuestion> questions;
  final List<ScaleInterpretation> interpretations;

  ClinicalScale({
    required this.id, required this.name, required this.fullName, 
    required this.category, required this.ageGroup, required this.instructions, 
    required this.questions, required this.interpretations
  });
}
