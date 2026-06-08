class IrpPlan {
  String goalsSmart;
  String mfkCodes;
  String interventionPlan;
  String specialistName;
  String rehabilitationCycle;
  int? plannedDays; // Додано
  Map<int, List<CustomExercise>>? daysSchedule; // Додано

  IrpPlan({
    this.goalsSmart = '',
    this.mfkCodes = '',
    this.interventionPlan = '',
    this.specialistName = '',
    this.rehabilitationCycle = 'Первинний',
    this.plannedDays = 3,
    this.daysSchedule,
  });
}

class Patient {
  final String id;
  final String name;
  final String age;
  final String birthDate; // Додано
  final String diagnosis;
  String diagnosisMkh10; // Додано
  final String admissionDate; // Додано
  final IrpPlan irp;
  final List<PatientVisit> visits;
  final List<ScaleHistoryPoint> scaleHistory;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.birthDate,
    required this.diagnosis,
    required this.diagnosisMkh10,
    required this.admissionDate,
    required this.irp,
    List<PatientVisit>? visits,
    List<ScaleHistoryPoint>? scaleHistory,
  })  : visits = visits ?? [],
        scaleHistory = scaleHistory ?? [];
}

class PatientVisit {
  final String id;
  DateTime date; // Змінено на DateTime
  String therapeuticNote;
  Map<String, String>? testResults;

  PatientVisit({
    required this.id,
    required this.date,
    this.therapeuticNote = '',
    this.testResults,
  });
}

class CustomExercise {
  final String id;
  final String title;
  final String dosage;

  CustomExercise({
    required this.id,
    required this.title,
    required this.dosage,
  });
}

class ScaleHistoryPoint {
  final String date;
  final String scaleName;
  final String score; // Залишаємо як String, але в коді треба буде конвертувати в double

  ScaleHistoryPoint({
    required this.date,
    required this.scaleName,
    required this.score,
  });
}
