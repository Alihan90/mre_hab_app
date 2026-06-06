// lib/models.dart

class Patient {
  String id;
  String name; // ПІБ українською
  String birthDate;
  String diagnosisMkh10; // Код та назва за МКХ-10
  String admissionDate;
  IrpPlan irp;
  List<PatientVisit> visits;
  List<ScaleHistoryPoint> scaleHistory; // Для динамічного графіка шкал

  Patient({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.diagnosisMkh10,
    required this.admissionDate,
    required this.irp,
    List<PatientVisit>? visits,
    List<ScaleHistoryPoint>? scaleHistory,
  })  : visits = visits ?? [],
        scaleHistory = scaleHistory ?? [];

  // Формування офіційного документа згідно з вимогами МОЗ України (ІРП)
  String generateMoxStatement() {
    String visitLogs = visits.isEmpty
        ? "Візити не зафіксовані.\n"
        : visits.map((v) => "- ${v.date.day}.${v.date.month}.${v.date.year}: ${v.therapeuticNote}").join("\n");

    String exerciseSchedule = "";
    if (irp.daysSchedule.isNotEmpty) {
      irp.daysSchedule.forEach((day, exercises) {
        exerciseSchedule += "\n[День $day]:\n" + exercises.map((e) => "  • ${e.title} (${e.dosage}) - Опір/Стрічка: ${e.isCustomized ? 'Так' : 'Стандарт'}").join("\n");
      });
    } else {
      exerciseSchedule = "Індивідуальний план вправ ще не згенеровано.";
    }

    return """
ЗАСТЕРЕЖЕННЯ: ОФІЦІЙНИЙ ДОКУМЕНТ ІРП (НАКАЗ МОЗ УКРАЇНИ)
==================================================
ЗАТВЕРДЖЕНО ІНДИВІДУАЛЬНИЙ РЕАБІЛІТАЦІЙНИЙ ПЛАН
Пацієнт: $name
Дата народження: $birthDate
Дата госпіталізації/початку: $admissionDate
Спеціаліст: ${irp.specialistName}
--------------------------------------------------
1. КЛІНІЧНИЙ ДІАГНОЗ (МКХ-10):
$diagnosisMkh10

2. КОДИ МКФ:
${irp.mfkCodes}

3. ЦІЛЬ ЗА СИСТЕМОЮ SMART:
${irp.goalsSmart}

4. ЦИКЛ РЕАБІЛІТАЦІЇ: ${irp.rehabilitationCycle}
5. ЗАГАЛЬНИЙ ПЛАН ВТРУЧАНЬ:
${irp.interventionPlan}

6. ІНДИВІДУАЛЬНИЙ ПЛАН ВПРАВ ЗА ДНЯМИ (На ${irp.plannedDays} днів): $exerciseSchedule

7. ЖУРНАЛ КЛІНІЧНИХ ВІЗИТІВ:
$visitLogs
==================================================
Документ сформовано автоматично в системі MReHab у 2026 році.
""";
  }
}

class IrpPlan {
  String goalsSmart;
  String mfkCodes;
  String rehabilitationCycle;
  String interventionPlan;
  String specialistName;
  int plannedDays; // Кількість днів, на яку розраховується план
  Map<int, List<CustomExercise>> daysSchedule; // День -> Список адаптованих вправ

  IrpPlan({
    this.goalsSmart = '',
    this.mfkCodes = '',
    this.rehabilitationCycle = 'Первинний',
    this.interventionPlan = '',
    this.specialistName = 'Ковальчук О.В.',
    this.plannedDays = 3,
    Map<int, List<CustomExercise>>? daysSchedule,
  }) : daysSchedule = daysSchedule ?? {};
}

class CustomExercise {
  String id;
  String title;
  String dosage;
  bool isCustomized; // Чи вносилися ручні зміни терапевтом

  CustomExercise({
    required this.id,
    required this.title,
    required this.dosage,
    this.isCustomized = false,
  });
}

class PatientVisit {
  String id;
  DateTime date;
  String therapeuticNote;
  Map<String, String> testResults; // Назва шкали -> Результат

  PatientVisit({
    required this.id,
    required this.date,
    required this.therapeuticNote,
    Map<String, String>? testResults,
  }) : testResults = testResults ?? {};
}

class ScaleHistoryPoint {
  final DateTime date;
  final String scaleName;
  final double score; // Числове значення для побудови динаміки графіку

  ScaleHistoryPoint({
    required this.date,
    required this.scaleName,
    required this.score,
  });
}
