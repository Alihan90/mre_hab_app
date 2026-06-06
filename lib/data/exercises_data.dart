enum ExerciseAgeGroup { child, adult, geriatric, all }

enum ExerciseIntensity { low, medium, high }

class Exercise {
  final String id;
  final String title;
  final String description;
  final List<String> executionSteps; // Покрокова інструкція
  final ExerciseAgeGroup ageGroup;
  final ExerciseIntensity intensity;
  final String category; // Наприклад: "Неврологія", "Дихальні"
  final String indications; // Показання (наприклад: "ДЦП Рівень I-II", "Постінсультний парез")
  final String contraindications; // Протипоказання за протоколами (Геріатрія/Гострий період)
  final String dosage; // Рекомендована доза (повтори, підходи, час)

  const Exercise({
    required this.id,
    required this.title,
    required this.description,
    required this.executionSteps,
    required this.ageGroup,
    required this.intensity,
    required this.category,
    required this.indications,
    required this.contraindications,
    required this.dosage,
  });
}
