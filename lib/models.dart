class IrpPlan {
  String goalsSmart;
  String mfkCodes;
  String interventionPlan;
  String specialistName; // Це те саме, що specialName, на яке сварився PatientsScreen
  String rehabilitationCycle;
  int? plannedDays;
  Map<int, List<CustomExercise>>? daysSchedule;

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

class CustomExercise {
  String id;
  String title;
  String dosage; // Тепер це змінна, а не final, щоб можна було робити setter
  bool isCustomized;

  CustomExercise({
    required this.id,
    required this.title,
    required this.dosage,
    this.isCustomized = false,
  });
}

class PatientVisit {
  String id;
  String date; // Змінили назад на String, щоб збігалося з patients_screen
  String therapeuticNote;
  Map<String, String>? testResults;

  PatientVisit({
    required this.id,
    required this.date,
    this.therapeuticNote = '',
    this.testResults,
  });
}

class Patient {
  final String id;
  final String name;
  final String age;
  final String birthDate;
  final String diagnosis;
  String diagnosisMkh10;
  final String admissionDate;
  final IrpPlan irp;
  final List<PatientVisit> visits;
  final List<ScaleHistoryPoint> scaleHistory;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    this.birthDate = '',
    this.diagnosis = '',
    this.diagnosisMkh10 = '',
    this.admissionDate = '',
    required this.irp,
    List<PatientVisit>? visits,
    List<ScaleHistoryPoint>? scaleHistory,
  })  : visits = visits ?? [],
        scaleHistory = scaleHistory ?? [];

  String generateMoxStatement() => "ІРП для $name";
}

class ScaleHistoryPoint {
  final String date;
  final String scaleName;
  final String score;

  ScaleHistoryPoint({
    required this.date,
    required this.scaleName,
    required this.score,
  });
}
