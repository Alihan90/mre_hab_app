// ==========================================
// 1. МОДЕЛІ ДЛЯ ІРП ТА ПАЦІЄНТІВ
// ==========================================

class IrpPlan {
  String goalsSmart;
  String mfkCodes;
  String interventionPlan;
  String specialistName;
  String rehabilitationCycle;

  IrpPlan({
    this.goalsSmart = '',
    this.mfkCodes = '',
    this.interventionPlan = '',
    this.specialistName = '',
    this.rehabilitationCycle = 'Первинний',
  });
}

class Patient {
  final String id;
  final String name;
  final String age;
  final String diagnosis;
  final IrpPlan irp;
  final List<PatientVisit> visits;
  final List<ScaleHistoryPoint> scaleHistory;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.diagnosis,
    required this.irp,
    List<PatientVisit>? visits,
    List<ScaleHistoryPoint>? scaleHistory,
  })  : visits = visits ?? [],
        scaleHistory = scaleHistory ?? [];
}

class PatientVisit {
  final String date;
  final List<CustomExercise> exercises;

  PatientVisit({
    required this.date,
    required this.exercises,
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
  final String score;

  ScaleHistoryPoint({
    required this.date,
    required this.scaleName,
    required this.score,
  });
}

// ==========================================
// 2. МОДЕЛІ ДЛЯ КАТАЛОГУ ВПРАВ (EXERCISES)
// ==========================================

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

// ==========================================
// 3. МОДЕЛІ ДЛЯ ГОНІОМЕТРІЇ (GONIOMETRY)
// ==========================================

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
