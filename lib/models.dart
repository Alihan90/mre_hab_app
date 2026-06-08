// lib/models.dart

// Структура даних для медичної карти пацієнта
class PatientCard {
  final String id;
  final String fullName;
  final String birthDate;
  final String primaryDiagnosis;
  List<String> smartGoals; 
  List<String> icdCodes;   
  List<String> assignedExercises;

  PatientCard({
    required this.id,
    required this.fullName,
    required this.birthDate,
    required this.primaryDiagnosis,
    required this.smartGoals,
    required this.icdCodes,
    required this.assignedExercises,
  });

  // Перетворюємо об'єкт пацієнта в Map для збереження в JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'birthDate': birthDate,
      'primaryDiagnosis': primaryDiagnosis,
      'smartGoals': smartGoals,
      'icdCodes': icdCodes,
      'assignedExercises': assignedExercises,
    };
  }

  // Створюємо об'єкт пацієнта з Map, прочитаного з JSON
  factory PatientCard.fromMap(Map<String, dynamic> map) {
    return PatientCard(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      birthDate: map['birthDate'] ?? '',
      primaryDiagnosis: map['primaryDiagnosis'] ?? '',
      smartGoals: List<String>.from(map['smartGoals'] ?? []),
      icdCodes: List<String>.from(map['icdCodes'] ?? []),
      assignedExercises: List<String>.from(map['assignedExercises'] ?? []),
    );
  }
}

// Структура даних для клінічних шкал
class ClinicalScale {
  final String name;
  final String category;
  final String description;
  final String instruction;
  final String interpretation;

  ClinicalScale({
    required this.name,
    required this.category,
    required this.description,
    required this.instruction,
    required this.interpretation,
  });
}
