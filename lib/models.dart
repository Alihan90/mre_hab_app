// lib/models.dart
class IrpPlan {
  String goalsSmart;
  String mfkCodes;
  String interventionPlan;
  String specialistName;
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
  String dosage;
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
  String date;
  String therapeuticNote;
  Map<String, String>? testResults;

  PatientVisit({
    required this.id,
    required this.date,
    this.therapeuticNote = '',
    this.testResults,
  });
}

class ScaleHistoryPoint {
  String date;
  String scaleName;
  String score;

  ScaleHistoryPoint({
    required this.date,
    required this.scaleName,
    required this.score,
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

enum ExerciseAgeGroup { all, adult, child, geriatric }
enum ExerciseIntensity { low, medium, high }

class Exercise {
  final String id;
  final String title;
  final String category;
  final String description;
  final String indications;
  final String contraindications;
  final String dosage;
  final List<String> executionSteps;
  final ExerciseAgeGroup ageGroup;
  final ExerciseIntensity intensity;

  Exercise({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.indications,
    required this.contraindications,
    required this.dosage,
    required this.executionSteps,
    required this.ageGroup,
    required this.intensity,
  });
}

class JointMovementNorm {
  final String jointName;
  final String movementType;
  final int normalValue;
  final String instruction;

  JointMovementNorm({
    required this.jointName,
    required this.movementType,
    required this.normalValue,
    required this.instruction,
  });
}
