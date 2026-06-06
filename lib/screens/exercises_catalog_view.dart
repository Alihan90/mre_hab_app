import 'package:flutter/material.dart';
import 'package:amre_hab_app/data/exercises_data.dart'; // Перевір, щоб шлях до файлу вправ був правильним

class ExercisesCatalogView extends StatelessWidget {
  const ExercisesCatalogView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Автоматично групуємо вправи з нашого репозиторію за категоріями
    final Map<String, List<Exercise>> groupedExercises = {};
    for (var ex in exercisesRepository.values) {
      if (!groupedExercises.containsKey(ex.category)) {
        groupedExercises[ex.category] = [];
      }
      groupedExercises[ex.category]!.add(ex);
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: groupedExercises.entries.map((categoryGroup) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок медичної категорії/нозології
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
              child: Text(
                categoryGroup.key,
                style: const TextStyle(
                  fontSize: 15, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.teal, // Використовуємо колір Teal для відмінності від синіх шкал
                ),
              ),
            ),
            
            // Список вправ усередині цієї категорії
            ...categoryGroup.value.map((exercise) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8.0),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ExpansionTile(
                  leading: const Icon(Icons.accessibility_new, color: Colors.teal),
                  title: Text(
                    exercise.title,
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      "🎯 Показання: ${exercise.indications}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Опис вправи
                          Text(
                            exercise.description, 
                            style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black87),
                          ),
                          const SizedBox(height: 12),
                          
                          // Покроковий протокол виконання
                          const Text(
                            "📋 Покрокова інструкція виконання:", 
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(height: 6),
                          ...exercise.executionSteps.map((step) => Padding(
                                padding: const EdgeInsets.only(bottom: 4.0, left: 4.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("• ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                                    Expanded(child: Text(step, style: const TextStyle(fontSize: 13))),
                                  ],
                                ),
                              )),
                          
                          const Divider(height: 24),
                          
                          // Дозування відповідно до норм МОЗ
                          Row(
                            children: [
                              const Icon(Icons.timer_outlined, size: 18, color: Colors.blueGrey),
                              const SizedBox(width: 6),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(color: Colors.black, fontSize: 13),
                                    children: [
                                      const TextSpan(text: "Дозування: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: exercise.dosage),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          
                          // Критично важливі протипоказання
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(color: Colors.red.shade100),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.warning_amber_rounded, size: 18, color: Colors.red.shade700),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(color: Colors.red.shade900, fontSize: 12),
                                      children: [
                                        const TextSpan(text: "⚠️ Протипоказання: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: exercise.contraindications),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 8),
          ],
        );
      }).toList(),
    );
  }
}
