// lib/screens/scales_catalog_screen.dart
import 'package:flutter/material.dart';
import 'goniometry_test_screen.dart';

class ScalesCatalogScreen extends StatefulWidget {
  final Function(String, String)? onScaleTested;

  const ScalesCatalogScreen({Key? key, this.onScaleTested}) : super(key: key);

  @override
  State<ScalesCatalogScreen> createState() => _ScalesCatalogScreenState();
}

class _ScalesCatalogScreenState extends State<ScalesCatalogScreen> {
  String _searchQuery = "";

  // Структурована база даних усіх клінічних шкал
  final List<Map<String, dynamic>> _pediatricScales = [
    {
      "category": "🧠 Неврологія (ДЦП, ЧМТ, СМА)",
      "items": [
        {"name": "GMFCS / GMFM-66 та GMFM-88", "desc": "Класифікація та динаміка великих моторних функцій дитини."},
        {"name": "MACS / Mini-MACS", "desc": "Класифікація маніпулятивних можливостей рук."},
        {"name": "EDACS", "desc": "Система оцінки безпеки та ефективності ковтання, їди й пиття."},
        {"name": "WeeFIM / PEDI", "desc": "Оцінка функціональної незалежності та обмежень життєдіяльності."},
        {"name": "HFMSE / CHOP INTEND", "desc": "Моторні шкали для пацієнтів зі спінальною м'язовою атрофією (СМА)."},
        {"name": "FMS (Functional Mobility Scale)", "desc": "Оцінка ходьби дитини на 3 дистанції (5, 50, 500 м) з/без допоміжних засобів."},
        {"name": "AIMS (Alberta Infant Motor Scale)", "desc": "Оцінка моторного розвитку немовлят у положеннях: живіт, спина, сидячи, стоячи."},
        {"name": "SatCo (Segmental Assessment of Trunk Control)", "desc": "Сегментарна оцінка контролю тулуба для визначення точного рівня необхідної опори."},
        {"name": "QUEST (Quality of Upper Extremity Skills Test)", "desc": "Тест якості навичок верхніх кінцівок (рухи, функції кисті, захисні реакції при ДЦП)."}
      ]
    },
    {
      "category": "🦴 Ортопедія, ревматологія та біль",
      "items": [
        {"name": "FLACC / Wong-Baker FACES", "desc": "Поведінкова та візуальна оцінки інтенсивності болю у дітей."},
        {"name": "PODCI / CHAQ", "desc": "Опитувальники функціонального стану при патологіях ОРА та ювенільному артриті."},
        {"name": "Faces Paediatric Pain Tool (FPPT)", "desc": "Інструмент визначення локалізації, інтенсивності та характеру болю у дітей старшого віку."}
      ]
    },
    {
      "category": "🗣️ Розвиток, поведінка та комунікація",
      "items": [
        {"name": "Bayley-III / CARS / GARS / ADOS-2 / M-CHAT-R/F", "desc": "Діагностика, скринінг розвитку, поведінки та аутизму."},
        {"name": "VABS (Vineland Adaptive Behavior Scales)", "desc": "Шкала адаптивної поведінки Вайнленд."},
        {"name": "CFCS (Communication Function Classification System)", "desc": "Система класифікації комунікативних функцій у щоденному спілкуванні."}
      ]
    }
  ];

  final List<Map<String, dynamic>> _adultScales = [
    {
      "category": "🧠 Неврологія, нейрореабілітація та нейропсихологія",
      "items": [
        {"name": "NIHSS / mRS / Індекс Бартел / FIM", "desc": "Гострий інсульт, загальна залежність та базова повсякденна активність."},
        {"name": "Fugl-Meyer Assessment (FMA)", "desc": "Глибока оцінка моторного відновлення після перенесеного інсульту."},
        {"name": "MoCA / MMSE", "desc": "Скринінг та моніторинг когнітивного дефіциту пацієнта."},
        {"name": "MAS (Модифікована шкала Ашворта) / Шкала Тардьє", "desc": "Оцінка спастичності. Тардьє враховує швидкість розтягування м'яза."},
        {"name": "BBS (Шкала балансу Берга) / Тест Tinetti / TUG", "desc": "Оцінка рівноваги, темпу ходьби та ризиків падіння маломобільних пацієнтів."},
        {"name": "UPDRS / EDSS / RLAS", "desc": "Специфічні шкали для хвороби Паркінсона, розсіяного склерозу та наслідків важкої ЧМТ."},
        {"name": "FAB (Frontal Assessment Battery)", "desc": "Батарея лобних тестів для оцінки регуляторних когнітивних функцій."},
        {"name": "BADS (Behavioural Assessment of the Dysexecutive Syndrome)", "desc": "Поведеніцька оцінка дисегexecutive-синдрому (порушень планування)."},
        {"name": "Rivermead Behavioral Memory Test (RBMT)", "desc": "Ривермідський тест поведінкової пам'яті для оцінки повсякденних мнестичних функцій."},
        {"name": "STREAM (Stroke Rehabilitation Assessment of Movement)", "desc": "Оцінка рухів для контролю динаміки відновлення моторних навичок після інсульту."}
      ]
    },
    {
      "category": "🦴 Ортопедія, травматологія та вертебрологія",
      "items": [
        {"name": "VAS / NPRS", "desc": "Візуально-аналогова та цифрова шкали суб'єктивної оцінки інтенсивності болю."},
        {"name": "WOMAC / DASH / QuickDASH / LEFS / Шкала Harris / KSS", "desc": "Специфічні інструменти оцінки функції суглобів та верхніх/нижніх кінцівок."},
        {"name": "ODI (Опитувальник Освестрі) / RMDQ", "desc": "Оцінка обмеження життєдіяльності та працездатності при гострому болю у спині."},
        {"name": "SPADI (Shoulder Pain and Disability Index)", "desc": "Індекс болю та обмеження життєдіяльності плечового суглоба."},
        {"name": "Foot and Ankle Ability Measure (FAAM)", "desc": "Інструмент оцінки функціональних можливостей стопи та гомілковостопного суглоба."},
        {"name": "NDI (Neck Disability Index)", "desc": "Індекс порушення життєдіяльності при болях у шийному відділі хребта."}
      ]
    },
    {
      "category": "🫁 Кардіо- та респіраторна реабілітація",
      "items": [
        {"name": "6MWT / Шкала Борга / Шкала mMRC / NYHA / SGRQ", "desc": "Оцінка толерантності до навантажень, задишки, серцевої та дихальної недостатності."},
        {"name": "ISWT (Incremental Shuttle Walking Test)", "desc": "Шатл-тест із наростаючою швидкістю ходьби для визначення аеробної спроможності."},
        {"name": "CAT (COPD Assessment Test)", "desc": "Опитувальник для оцінки впливу ХОЗЛ на самопочуття та повсякденне життя пацієнта."}
      ]
    },
    {
      "category": "🍽️ Дисфагія, нутритивний статус та логопедія",
      "items": [
        {"name": "GUSS (Gugging Swallowing Screen)", "desc": "Скринінговий тест для швидкої та безпечної оцінки ковтання біля ліжка пацієнта."},
        {"name": "MASA (Mann Assessment of Swallowing Ability)", "desc": "Тест Манн для детальної клінічної оцінки здатності до ковтання."},
        {"name": "FOIS (Functional Oral Intake Scale)", "desc": "Шкала функціонального перорального прийому їжі (рівні 1-7 при дисфагії)."},
        {"name": "MNA (Mini Nutritional Assessment)", "desc": "Коротка оцінка нутритивного статусу у літніх людей для виявлення ризику виснаження."},
        {"name": "ASHA FACS", "desc": "Шкала оцінки функціональних комунікативних навичок для дорослих з порушеннями мовлення."}
      ]
    },
    {
      "category": "👵 Геріатрія, психічний стан та паліативна допомога",
      "items": [
        {"name": "Шкала Карновського / ECOG-WHO / Шкала FAST / GDS", "desc": "Оцінка загальної активності пацієнта, стадій деменції та геріатричної депресії."},
        {"name": "HADS (Hospital Anxiety and Depression Scale)", "desc": "Госпітальна шкала тривоги та депресії для швидкого скринінгу психоемоційного стану."},
        {"name": "Zarit Burden Interview (ZBI)", "desc": "Опитувальник тягаря догляду для оцінки навантаження на родичів/опікунів пацієнта."}
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
                  labelText: "Пошук за назвою або симптоматикою",
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
                                fixedSize: const Size(110, 36), // ТУТ ВИПРАВЛЕНО НА ПРАВИЛЬНИЙ fixedSize
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              icon: const Icon(Icons.play_arrow, size: 16),
                              label: const Text("Тестувати", style: TextStyle(fontSize: 12)),
                              onPressed: () {
                                if (widget.onScaleTested != null) {
                                  widget.onScaleTested!(item["name"], "Проведено тестування за шкалою.");
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Запущено форму: ${item["name"]}")),
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
