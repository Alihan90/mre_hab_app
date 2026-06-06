// lib/data/scales_data.dart

enum ScaleType {
  yesNoList,      // Список питань Так/Ні (1 або 0 балів) - Рівермід, Роланд-Морріс
  singleChoice,   // Скринінг за рівнями / Оксфордська шкала - GMFCS, MAS, MMT, mRS
  multiRadioGroup // Кожне питання має свої унікальні варіанти - NIHSS, Бартел, FIM, Берг
}

class ScaleOption {
  final int score;
  final String text;
  const ScaleOption(this.score, this.text);
}

class ScaleQuestion {
  final String id;
  final String text;
  final List<ScaleOption> options; // Використовується для multiRadioGroup та singleChoice
  const ScaleQuestion({required this.id, required this.text, this.options = const []});
}

class ScaleProtocol {
  final String id;
  final String name;
  final ScaleType type;
  final List<ScaleQuestion> questions;
  final List<ScaleOption> globalOptions; // Використовується, якщо варіанти відповідей однакові для всіх питань (наприклад, ММТ 0-5 або GMFCS)
  final String Function(int totalScore)? interpreter;

  const ScaleProtocol({
    required this.id,
    required this.name,
    required this.type,
    this.questions = const [],
    this.globalOptions = const [],
    this.interpreter,
  });
}

// БАЗА ДАНИХ КЛІНІЧНИХ ПРОТОКОЛІВ
final Map<String, ScaleProtocol> clinicalScalesRegistry = {
  
  // 1. ІНДЕКС БАРТЕЛ (Barthel Index) - Офіційний протокол ADL
  "BARTHEL": ScaleProtocol(
    id: "BARTHEL",
    name: "Індекс активності повсякденного життя Бартел (Barthel Index)",
    type: ScaleType.multiRadioGroup,
    interpreter: (score) {
      if (score <= 20) return "Повна залежність у повсякденному житті (0-20 балів)";
      if (score <= 60) return "Тяжка залежність (21-60 балів)";
      if (score <= 90) return "Помірна залежність (61-90 балів)";
      if (score <= 99) return "Легка залежність (91-99 балів)";
      return "Повна незалежність (100 балів)";
    },
    questions: [
      ScaleQuestion(id: "b1", text: "1. Прийом їжі", options: [
        ScaleOption(0, "0 — Потребує допомоги (введення зонда, годування)"),
        ScaleOption(5, "5 — Потребує допомоги при розрізанні їжі, намазуванні масла тощо"),
        ScaleOption(10, "10 — Самостійно (їжа подається на відстані витягнутої руки)")
      ]),
      ScaleQuestion(id: "b2", text: "2. Прийом ванни / душу", options: [
        ScaleOption(0, "0 — Потребує сторонньої допомоги"),
        ScaleOption(5, "5 — Самостійно (без сторонньої допомоги)")
      ]),
      ScaleQuestion(id: "b3", text: "3. Гігієнічні процедури (вмивання, гоління, чищення зубів)", options: [
        ScaleOption(0, "0 — Потребує сторонньої допомоги"),
        ScaleOption(5, "5 — Самостійно (включаючи підготовку інструментів)")
      ]),
      ScaleQuestion(id: "b4", text: "4. Одягання", options: [
        ScaleOption(0, "0 — Повна залежність від сторонньої допомоги"),
        ScaleOption(5, "5 — Частково потребує допомоги (наприклад, зашнурувати взуття)"),
        ScaleOption(10, "10 — Повністю самостійно (включаючи застібки та ґудзики)")
      ]),
      ScaleQuestion(id: "b5", text: "5. Контроль дефекації", options: [
        ScaleOption(0, "0 — Не тримання (або потреба в клізмах)"),
        ScaleOption(5, "5 — Випадкові інциденти (не частіше 1 разу на тиждень)"),
        ScaleOption(10, "10 — Повний контроль")
      ]),
      ScaleQuestion(id: "b6", text: "6. Контроль сечовипускання", options: [
        ScaleOption(0, "0 — Не тримання (або використання катетера без самообслуговування)"),
        ScaleOption(5, "5 — Випадкові інциденти (максимум 1 раз на добу)"),
        ScaleOption(10, "10 — Повний контроль (у т.ч. самостійне обслуговування катетера)")
      ]),
      ScaleQuestion(id: "b7", text: "7. Користування туалетом", options: [
        ScaleOption(0, "0 — Повна залежність від допомоги"),
        ScaleOption(5, "5 — Часткова допомога (утримання рівноваги, використання паперу)"),
        ScaleOption(10, "10 — Самостійно (вхід, вихід, роздягання, використання паперу)")
      ]),
      ScaleQuestion(id: "b8", text: "8. Трансфер (пересадка з ліжка на стілець і назад)", options: [
        ScaleOption(0, "0 — Повна залежність, пацієнт не сидить"),
        ScaleOption(5, "5 — Потребує значної допомоги (1-2 особи, фізична підтримка)"),
        ScaleOption(10, "10 — Незначна допомога (вербальні підказки або легка опора)"),
        ScaleOption(15, "15 — Повністю самостійно та безпечно")
      ]),
      ScaleQuestion(id: "b9", text: "9. Мобільність (пересування у приміщенні)", options: [
        ScaleOption(0, "0 — Нездатний до пересування"),
        ScaleOption(5, "5 — Самостійно у кріслі-колісному (понад 50 метрів, керування ручне)"),
        ScaleOption(10, "10 — Ходьба за допомогою однієї особи (або з ходунками)"),
        ScaleOption(15, "15 — Повністю самостійна ходьба без допомоги (допускається тростина)")
      ]),
      ScaleQuestion(id: "b10", text: "10. Подолання сходів", options: [
        ScaleOption(0, "0 — Нездатний долати сходи"),
        ScaleOption(5, "5 — Потребує допомоги або нагляду"),
        ScaleOption(10, "10 — Самостійно піднімається та спускається")
      ]),
    ],
  ),

  // 2. ІНДЕКС РІВЕРМІД (Rivermead Mobility Index)
  "RMDQ": ScaleProtocol(
    id: "RMDQ",
    name: "Індекс мобільності Рівермід (Rivermead)",
    type: ScaleType.yesNoList,
    interpreter: (score) => "Рівень мобільності пацієнта: $score з 15 балів. " + (score > 12 ? "Висока автономність." : (score > 6 ? "Помірна залежність." : "Важкі рухові обмеження.")),
    questions: [
      ScaleQuestion(id: "r1", text: "1. Повертання в ліжку: Чи можете ви самостійно повернутися з боку на бік?"),
      ScaleQuestion(id: "r2", text: "2. Перехід із положення лежачи в сидячи: Чи можете ви самостійно сісти на край ліжка?"),
      ScaleQuestion(id: "r3", text: "3. Утримання рівноваги сидячи: Чи можете ви сидіти на стільці без опори 10 хвилин?"),
      ScaleQuestion(id: "r4", text: "4. Перехід із сидячи в стоячи: Чи можете ви встати без допомоги рук?"),
      ScaleQuestion(id: "r5", text: "5. Стояння без підтримки: Чи можете ви стояти без опори та допомоги 1 хвилину?"),
      ScaleQuestion(id: "r6", text: "6. Пересадка (трансфер): Чи можете ви самостійно пересісти з ліжка на стілець?"),
      ScaleQuestion(id: "r7", text: "7. Ходьба по кімнаті: Чи можете ви пройти 10 метрів у межах кімнати з палицею/ходунками?"),
      ScaleQuestion(id: "r8", text: "8. Ходьба в приміщенні: Чи можете ви самостійно ходити по квартирі/відділенню?"),
      ScaleQuestion(id: "r9", text: "9. Ходьба по вулиці: Чи можете ви самостійно пройти 50 метрів по рівній поверхні?"),
      ScaleQuestion(id: "r10", text: "10. Опора на одну ногу: Чи можете ви встояти на одній нозі без підтримки 5 секунд?"),
      ScaleQuestion(id: "r11", text: "11. Підйом по сходах: Чи можете ви піднятися на один проліт сходів без допомоги?"),
      ScaleQuestion(id: "r12", text: "12. Ходьба по нерівній поверхні: Чи можете ви безпечно ходити по траві чи бруківці?"),
      ScaleQuestion(id: "r13", text: "13. Пересування у ванні: Чи можете ви самостійно залізти та вилізти з ванни?"),
      ScaleQuestion(id: "r14", text: "14. Подолання перешкод: Чи можете ви переступити через невеликий бордюр або сходинку?"),
      ScaleQuestion(id: "r15", text: "15. Біг / Швидка ходьба: Чи можете ви пробігти 10 метрів за 4 секунди?")
    ],
  ),

  // 3. МАНУАЛЬНЕ М'ЯЗОВЕ ТЕСТУВАННЯ (MMT - Oxford Scale)
  "MMT": ScaleProtocol(
    id: "MMT",
    name: "Оцінка м'язової сили (Manual Muscle Testing)",
    type: ScaleType.singleChoice,
    interpreter: (score) => "Оцінка м'язової сили за Оксфордським протоколом завершена.",
    globalOptions: [
      ScaleOption(5, "5 — Нормальна сила проти повного опору"),
      ScaleOption(4, "4 — Рух проти сили тяжіння з помірним опором терапевта"),
      ScaleOption(3, "3 — Рух у повному обсязі виключно проти сили тяжіння"),
      ScaleOption(2, "2 — Рух у повному обсязі лише у площині столу (без сили тяжіння)"),
      ScaleOption(1, "1 — Візуальні або пальпаторні сліди скорочення, руху немає"),
      ScaleOption(0, "0 — Повна відсутність ознак скорочення м'яза")
    ],
    questions: [
      ScaleQuestion(id: "m1", text: "Згиначі шиї"),
      ScaleQuestion(id: "m2", text: "Відведення плеча (m. deltoideus)"),
      ScaleQuestion(id: "m3", text: "Згинання ліктя (m. biceps)"),
      ScaleQuestion(id: "m4", text: "Розгинання ліктя (m. triceps)"),
      ScaleQuestion(id: "m5", text: "Розгиначі кисті"),
      ScaleQuestion(id: "m6", text: "Згиначі стегна (m. iliopsoas)"),
      ScaleQuestion(id: "m7", text: "Розгиначі коліна (m. quadriceps)"),
      ScaleQuestion(id: "m8", text: "Тильне згинання стопи (m. tibialis anterior)")
    ],
  ),

  // 4. ДИТЯЧА КЛАСИФІКАЦІЯ GMFCS (Великі моторні функції ДЦП)
  "GMFCS": ScaleProtocol(
    id: "GMFCS",
    name: "Система класифікації великих моторних функцій (GMFCS)",
    type: ScaleType.singleChoice,
    interpreter: (score) => "Визначено Рівень за класифікацією GMFCS: Рівень $score.",
    globalOptions: [
      ScaleOption(1, "Рівень I — Ходьба без обмежень (труднощі лише при високих координаційних навантаженнях)"),
      ScaleOption(2, "Рівень II — Ходьба з обмеженнями (труднощі на вулиці, при ходьбі по нерівній поверхні)"),
      ScaleOption(3, "Рівень III — Ходьба з використанням ручних допоміжних засобів (ходунці, милиці)"),
      ScaleOption(4, "Рівень IV — Самостійне пересування обмежене (пацієнт транспортується або використовує електроколяску)"),
      ScaleOption(5, "Рівень V — Перевезення у кріслі-колісному (повне обмеження самостійного контролю пози)")
    ],
    questions: [
      ScaleQuestion(id: "g1", text: "Оберіть поточний рівень функціональних можливостей дитини згідно з її віковим діапазоном:")
    ],
  ),

  // 5. МОДИФІКОВАНА ШКАЛА РЕНКІНА (mRS)
  "MRS": ScaleProtocol(
    id: "MRS",
    name: "Модифікована шкала Ренкіна (mRS)",
    type: ScaleType.singleChoice,
    interpreter: (score) {
      if (score == 0) return "0 — Немає симптомів";
      if (score == 1) return "1 — Відсутність суттєвих порушень (виконує звичні справи)";
      if (score == 2) return "2 — Легка інвалідність (не може виконувати колишню активність, але обслуговує себе)";
      if (score == 3) return "3 — Помірна інвалідність (потребує певної допомоги, але ходить самостійно)";
      if (score == 4) return "4 — Виражена інвалідність (не може ходити без сторонньої допомоги)";
      return "5 — Тяжка інвалідність (прикутий до ліжка, постійний догляд)";
    },
    globalOptions: [
      ScaleOption(0, "0 — Симптомів немає"),
      ScaleOption(1, "1 — Симптоми не заважають повсякденній активності"),
      ScaleOption(2, "2 — Пацієнт не може вести колишній спосіб життя, але повністю обслуговує себе"),
      ScaleOption(3, "3 — Потребує допомоги при ходьбі чи самообслуговуванні, але пересувається самостійно"),
      ScaleOption(4, "4 — Нездатний ходити або забезпечувати базові потреби без сторонньої допомоги"),
      ScaleOption(5, "5 — Повний нагляд, інвалідизація, ліжковий режим")
    ],
    questions: [
      ScaleQuestion(id: "mrs1", text: "Оцініть ступінь обмеження життєдіяльності після інсульту:")
    ]
  )
};
