// lib/screens/scales_catalog_screen.dart
import 'package:flutter/material.dart';
import 'goniometry_test_screen.dart';
import 'scale_form_screen.dart'; // Імпортуємо новий файл форм

class ScalesCatalogScreen extends StatefulWidget {
  final Function(String, String)? onScaleTested;

  const ScalesCatalogScreen({Key? key, this.onScaleTested}) : super(key: key);

  @override
  State<ScalesCatalogScreen> createState() => _ScalesCatalogScreenState();
}

class _ScalesCatalogScreenState extends State<ScalesCatalogScreen> {
  String _searchQuery = "";

  // ПЕДІАТРИЧНІ ШКАЛИ — повністю розділені на незалежні одиниці
  final List<Map<String, dynamic>> _pediatricScales = [
    {
      "category": "🧠 Неврологія (Дитячий вік, ДЦП, ЧМТ, СМА)",
      "items": [
        {"id": "GMFCS", "name": "GMFCS", "desc": "Система класифікації великих моторних функцій дитини за рівнями (I-V)."},
        {"id": "GMFM66", "name": "GMFM-66", "desc": "Оцінка динаміки великих моторних функцій (скорочена клінічна версія, 66 пунктів)."},
        {"id": "GMFM88", "name": "GMFM-88", "desc": "Повна шкала вимірювання великих моторних функцій у дітей з ДЦП (88 пунктів)."},
        {"id": "MACS", "name": "MACS", "desc": "Класифікація маніпулятивних можливостей та дрібної моторики рук."},
        {"id": "MINI_MACS", "name": "Mini-MACS", "desc": "Класифікація маніпулятивних можливостей рук для дітей раннього віку (від 1 до 4 років)."},
        {"id": "EDACS", "name": "EDACS", "desc": "Система оцінки безпеки та ефективності ковтання, їди й пиття у повсякденному житті."},
        {"id": "WEEFIM", "name": "WeeFIM", "desc": "Шкала функціональної незалежності дітей (оцінка обмежень від 6 міс до 7 років)."},
        {"id": "PEDI", "name": "PEDI", "desc": "Опитувальник оцінки functional стану та обмежень життєдіяльності у дітей."},
        {"id": "HFMSE", "name": "HFMSE", "desc": "Моторна шкала Хаммерсміта для пацієнтів зі спінальною м'язовою атрофією (СМА)."},
        {"id": "CHOP_INTEND", "name": "CHOP INTEND", "desc": "Рухова шкала для оцінки немовлят та дітей з важкими нервово-м'язовими захворюваннями (СМА 1)."},
        {"id": "FMS", "name": "FMS (Functional Mobility Scale)", "desc": "Шкала функціональної мобільності для оцінки ходьби дитини на 5, 50 та 500 метрів."},
        {"id": "AIMS", "name": "AIMS", "desc": "Шкала рухового розвитку немовлят Альберти від народження до самостійної ходьби."},
        {"id": "SatCo", "name": "SatCo (Segmental Assessment of Trunk Control)", "desc": "Сегментарна оцінка контролю тулуба для визначення точного рівня необхідної опори."},
        {"id": "QUEST", "name": "QUEST", "desc": "Тест якості навичок верхніх кінцівок (оцінка рухів, функцій кисті та захисних реакцій)."}
      ]
    },
    {
      "category": "🦴 Ортопедія, ревматологія та біль (Діти)",
      "items": [
        {"id": "FLACC", "name": "FLACC", "desc": "Поведінкова шкала оцінки інтенсивності болю за мімікою, рухом ніг, плачем та утішанням."},
        {"id": "WONG_BAKER", "name": "Wong-Baker FACES", "desc": "Візуальна шкала оцінки інтенсивності болю за виразом облич на малюнках."},
        {"id": "PODCI", "name": "PODCI", "desc": "Опитувальник функціонального стану опорно-рухового апарату та результатів лікування у дітей."},
        {"id": "CHAQ", "name": "CHAQ", "desc": "Опитувальник функціонального стану дитини при ювенільному ідіопатичному артриті."},
        {"id": "FPPT", "name": "Faces Paediatric Pain Tool (FPPT)", "desc": "Інструмент визначення точної локалізації, інтенсивності та характеру болю у дітей."}
      ]
    },
    {
      "category": "🗣️ Розвиток, поведінка, аутизм та комунікація",
      "items": [
        {"id": "BAYLEY3", "name": "Bayley-III", "desc": "Шкали комплексного оцінювання розвитку немовлят і дітей раннього віку."},
        {"id": "CARS", "name": "CARS", "desc": "Рейтингова шкала дитячого аутизму для первинного скринінгу."},
        {"id": "GARS", "name": "GARS", "desc": "Шкала оцінки тяжкості проявів аутизму Гілліама."},
        {"id": "ADOS2", "name": "ADOS-2", "desc": "План діагностичного обстеження при аутизмі (золотий стандарт діагностики)."},
        {"id": "MCHAT", "name": "M-CHAT-R/F", "desc": "Модифікований скринінговий тест на аутизм для дітей раннього віку з алгоритмом відстеження."},
        {"id": "VABS", "name": "VABS (Vineland Adaptive Behavior Scales)", "desc": "Шкала адаптивної поведінки Вайнленд для оцінки особистої та соціальної незалежності."},
        {"id": "CFCS", "name": "CFCS", "desc": "Система класифікації комунікативних функцій для визначення ефективності щоденного спілкування."}
      ]
    }
  ];
  // ДОРОСЛІ ШКАЛИ — повністю розділені на незалежні одиниці
  final List<Map<String, dynamic>> _adultScales = [
    {
      "category": "🧠 Неврологія, нейрореабілітація та нейропсихологія",
      "items": [
        {"id": "NIHSS", "name": "NIHSS", "desc": "Шкала інсульту Національних інститутів здоров'я для оцінки неврологічного дефіциту."},
        {"id": "ASIA", "name": "ASIA Impairment Scale", "desc": "Міжнародний стандарт неврологічної класифікації травм спинного мозку."},
        {"id": "BARTHEL", "name": "Індекс Бартел (Barthel Index)", "desc": "Оцінка базової повсякденної активності та ступеня незалежності пацієнта (0-100 балів)."},
        {"id": "FIM", "name": "FIM", "desc": "Шкала функціональної незалежності для комплексного моніторингу етапів реабілітації."},
        {"id": "FMA_UE", "name": "Fugl-Meyer Assessment (FMA-UE)", "desc": "Оцінка моторного відновлення, синергій та ізольованих рухів верхньої кінцівки після інсульту."},
        {"id": "ARAT", "name": "Action Research Arm Test (ARAT)", "desc": "Клінічний тест маніпулятивної функції руки, захоплення та утримання предметів."},
        {"id": "NHPT", "name": "Nine-Hole Peg Test (NHPT)", "desc": "Тест дев'яти кілочків для точного вимірювання дрібної моторики та спритності пальців."},
        {"id": "MAS", "name": "MAS (Модифікована шкала Ашворта)", "desc": "Клінічна оцінка ступеня м'язової спастичності при пасивних рухах кінцівки. (АКТИВНА)"},
        {"id": "TARDIEU", "name": "Шкала Тардьє (Tardieu Scale)", "desc": "Оцінка спастичності з точним урахуванням швидкості розтягування м'яза (V1, V2, V3)."},
        {"id": "BBS", "name": "BBS (Шкала балансу Берга)", "desc": "Оцінка статичної та динамічної рівноваги, визначення ризику падінь (14 завдань). (АКТИВНА)"},
        {"id": "TINETTI", "name": "Тест Tinetti (POMA)", "desc": "Оцінка балансу, стабільності ходьби та загального ризику падінь у дорослих."},
        {"id": "TUG", "name": "Тест TUG (Timed Up and Go)", "desc": "Функціональний швидкісний тест 'Встань та йди' для оцінки мобільності."},
        {"id": "MOCA", "name": "MoCA (Монреальська шкала когнітивної оцінки)", "desc": "Швидкий скринінг та виявлення когнітивного дефіциту (пам'ять, увага, мова)."},
        {"id": "MMSE", "name": "MMSE", "desc": "Коротка шкала психічного статусу пацієнта для первинної оцінки деменції."},
        {"id": "BDI", "name": "Шкала депресії Бека (BDI)", "desc": "Клінічний скринінг емоційного стану пацієнта та виявлення депресивного синдрому."},
        {"id": "UPDRS", "name": "UPDRS", "desc": "Уніфікована шкала оцінки проявів та стадій хвороби Паркінсона."},
        {"id": "EDSS", "name": "EDSS (Шкала Куртцке)", "desc": "Розширена шкала статусу інвалідизації у пацієнтів з розсіяним склерозом."},
        {"id": "RLAS", "name": "RLAS (Шкала Ранчо Лос Амігос)", "desc": "Оцінка рівнів поведінкового та когнітивного функціонування після важкої ЧМТ."},
        {"id": "FAB", "name": "FAB (Frontal Assessment Battery)", "desc": "Батарея лобних тестів для експрес-діагностики дефіциту регуляторних когнітивних функцій."},
        {"id": "BADS", "name": "BADS", "desc": "Поведінкова оцінка дисегexecutive-синдрому (порушень планування у повсякденному житті)."},
        {"id": "RBMT", "name": "Rivermead Тест Пам'яті", "desc": "Ривермідський тест поведінкової пам'яті для оцінки повсякденних мнестичних функцій."},
        {"id": "STREAM", "name": "STREAM", "desc": "Оцінка рухів та моторних навичок для контролю динаміки відновлення після інсульту."}
      ]
    },
    {
      "category": "🦴 Ортопедія, травматологія та вертебрологія",
      "items": [
        {"id": "PAIN_SCALE", "name": "Шкала болю", "desc": "Інтегрована візуально-аналогова та цифрова шкала оцінки інтенсивності болю пацієнтом (0-10)."},
        {"id": "VAS", "name": "VAS (Візуально-аналогова шкала)", "desc": "Суб'єктивна оцінка інтенсивності болю пацієнтом від 0 до 10."},
        {"id": "NPRS", "name": "NPRS (Цифрова шкала болю)", "desc": "Градуйована оцінка рівня болю від 0 (немає болю) до 10 (найгірший біль)."},
        {"id": "WOMAC", "name": "Індекс WOMAC", "desc": "Опитувальник для оцінки болю, скутості та функції суглобів при остеоартрозі."},
        {"id": "DASH", "name": "DASH", "desc": "Опитувальник обмежень життєдіяльності та рухової функції верхньої кінцівки."},
        {"id": "QUICK_DASH", "name": "QuickDASH", "desc": "Скорочений варіант опитувальника функції руки (11 ключових запитань)."},
        {"id": "LEFS", "name": "LEFS", "desc": "Шкала функціонального стану нижньої кінцівки при ортопедичних патологіях."},
        {"id": "HARRIS", "name": "Шкала Harris", "desc": "Оцінка больового синдрому та функціональних можливостей кульшового суглоба."},
        {"id": "KSS", "name": "KSS (Knee Society Score)", "desc": "Специфічний клінічний інструмент оцінки функції та стабільності колінного суглоба."},
        {"id": "ODI", "name": "ODI (Опитувальник Освестрі)", "desc": "Індекс обмеження життєдіяльності та працездатності при гострому болю у попереку."},
        {"id": "RMDQ", "name": "Опитувальник Роланда-Морріса", "desc": "Оцінка специфічних рухових обмежень, викликаних болем у нижній частині спини."},
        {"id": "SPADI", "name": "Індекс SPADI", "desc": "Оцінка інтенсивності болю та обмеження життєдіяльності плечового суглоба."},
        {"id": "FAAM", "name": "FAAM", "desc": "Інструмент оцінки функціональних можливостей стопи та гомілковостопного суглоба."},
        {"id": "NDI", "name": "NDI (Neck Disability Index)", "desc": "Індекс порушення повсякденної життєдіяльності пацієнта при болях у шийному відділі."}
      ]
    },
    {
      "category": "🫁 Кардіо- та респіраторна реабілітація",
      "items": [
        {"id": "6MWT", "name": "6MWT (Тест 6-хвилинної ходьби)", "desc": "Визначення відстані ходьби для оцінки толерантності до субмаксимальних фізичних навантажень."},
        {"id": "BORG", "name": "Шкала Борга", "desc": "Клінічна шкала суб'єктивного сприйняття важкості задишки та фізичного навантаження."},
        {"id": "MMRC", "name": "Шкала mMRC", "desc": "Модифікована шкала Медичної дослідницької ради для градації тяжкості дихальних розладів."},
        {"id": "NYHA", "name": "Класифікація NYHA", "desc": "Визначення функціональних класів пацієнтів з хронічною серцевою недостатністю."},
        {"id": "SGRQ", "name": "Опитувальник Святого Георгія", "desc": "Стандартизована оцінка якості життя дихальних пацієнтів (ХОЗЛ, астма)."},
        {"id": "ISWT", "name": "ISWT (Incremental Shuttle Walking Test)", "desc": "Шатл-тест із наростаючою швидкістю ходьби під звуковий сигнал для оцінки аеробної спроможності."},
        {"id": "CAT", "name": "CAT (COPD Assessment Test)", "desc": "Опитувальник для точного вимірювання впливу ХОЗЛ на самопочуття пацієнта."}
      ]
    },
    {
      "category": "👵 Геріатрія, життєдіяльність та догляд",
      "items": [
        {"id": "BRADEN", "name": "Шкала Брейден (Braden Scale)", "desc": "Клінічна оцінка та прогнозування ризику розвитку пролежнів у малорухомих пацієнтів."},
        {"id": "EMS", "name": "Elderly Mobility Scale (EMS)", "desc": "Шкала мобільності літніх людей для оцінки рівноваги, ходьби та безпеки трансферу."},
        {"id": "IADL", "name": "Індекс Lawton IADL", "desc": "Шкала оцінки інструментальної (побутової) активності та незалежності пацієнта в соціумі."},
        {"id": "FAST", "name": "Шкала FAST", "desc": "Система оцінки стадій та функціонального згасання при прогресуванні деменції."},
        {"id": "GDS", "name": "GDS (Geriatric Depression Scale)", "desc": "Геріатрична шкала депресії для швидкого скринінгу психоемоційного стану літніх людей."},
        {"id": "HADS", "name": "Шкала HADS", "desc": "Госпітальна шкала тривоги та депресії для швидкого скринінгу загального стану."},
        {"id": "ZBI", "name": "Zarit Burden Interview (ZBI)", "desc": "Опитувальник для оцінки фізичного та психологичного навантаження на опікунів пацієнта."}
      ]
    },
    {
      "category": "🍽️ Дисфагія, нутритивний статус та інтенсивна терапія",
      "items": [
        {"id": "RASS", "name": "Шкала седації-ажитації Richmond (RASS)", "desc": "Оцінка рівня свідомості, психомоторного збудження або глибини седації пацієнта."},
        {"id": "GUSS", "name": "GUSS (Gugging Swallowing Screen)", "desc": "Швидкий скринінговий тест для безпечної оцінки ковтання біля ліжка пацієнта після інсульту."},
        {"id": "MASA", "name": "MASA", "desc": "Тест Манн для детальної клінічної та інструментальної оцінки здатності до ковтання."},
        {"id": "FOIS", "name": "FOIS", "desc": "Шкала функціонального перорального прийому їжі (рівні від 1 до 7 для пацієнтів з дисфагією)."},
        {"id": "MNA", "name": "MNA (Mini Nutritional Assessment)", "desc": "Коротка оцінка нутритивного статусу у літніх людей для виявлення ризиків мальнутриції."},
        {"id": "ASHA_FACS", "name": "ASHA FACS", "desc": "Шкала оцінки функціональних комунікативних навичок для дорослих з порушеннями мовлення."}
      ]
    }
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Клінічні оцінки та шкали"),
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.child_care), text: "Дитячі"),
              Tab(icon: Icon(Icons.accessibility), text: "Дорослі"),
              Tab(icon: Icon(Icons.straighten), text: "Гоніометрія"),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Пошук шкал за назвою або ключовим словом...",
                  prefixIcon: const Icon(Icons.search, color: Colors.blue),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildCatalogTab(_pediatricScales),
                  _buildCatalogTab(_adultScales),
                  GoniometryInteractiveTestScreen(onSaveResult: widget.onScaleTested),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCatalogTab(List<Map<String, dynamic>> sourceData) {
    List<Widget> categoryWidgets = [];

    for (var cat in sourceData) {
      List<dynamic> filteredItems = cat["items"].where((item) {
        String name = item["name"].toString().toLowerCase();
        String desc = item["desc"].toString().toLowerCase();
        return name.contains(_searchQuery) || desc.contains(_searchQuery);
      }).toList();

      if (filteredItems.isNotEmpty) {
        categoryWidgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 14, left: 12, right: 12, bottom: 6),
            child: Text(
              cat["category"],
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
            ),
          ),
        );

        categoryWidgets.addAll(
          filteredItems.map((item) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade50,
                  child: const Icon(Icons.assignment, size: 20, color: Colors.blue),
                ),
                title: Text(
                  item["name"],
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item["desc"], style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                                foregroundColor: Colors.white,
                                fixedSize: const Size(125, 36),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              icon: const Icon(Icons.play_arrow, size: 16),
                              label: const Text("Тестувати", style: TextStyle(fontSize: 12)),
                              onPressed: () {
                                // Навігація на новий універсальний екран форм
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ScaleFormScreen(
                                      scaleId: item["id"],
                                      scaleName: item["name"],
                                      onSave: widget.onScaleTested,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }).toList(),
        );
      }
    }

    if (categoryWidgets.isEmpty) {
      return const Center(child: Text("Шкал за таким запитом не знайдено."));
    }

    return ListView(children: categoryWidgets);
  }
}
