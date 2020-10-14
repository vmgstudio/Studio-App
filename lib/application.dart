import 'main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApplicationPage extends StatefulWidget {
  @override
  _ApplicationPageState createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  ApplicationData applicationData = new ApplicationData();

  double fieldWidth() {
    if (MediaQuery.of(context).size.width < Consts.mobileWidth)
      return MediaQuery.of(context).size.width;
    else
      return MediaQuery.of(context).size.width / 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: MobileAppBar("Jelentkezés"),
      body: Column(
        children: [
          TopBar(),
          Flexible(
            child: SingleChildScrollView(
              child: Form(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Column(
                      children: [
                        SelectableText('Jelentkezés',
                            style: Theme.of(context).textTheme.headline4,
                            textAlign: TextAlign.center),
                        SelectableText(
                            'Szia! Üdvözöllek a VMG Stúdió jelentkezési felületén! Ha jelentkezni szeretnél, jó helyen jársz.\n\nElső körben az alábbi jelentkezési lapot kell kitöltened. Fontos, hogy az adatokat pontosan add meg! Ez a későbbi kapcsolattartás szempontjából kulcsfontosságú. A jelentkezési lap beküldése után a rendszer rögzíti a beküldött jelentkezési lapot. \n\nSzeretjük a precíz, pontos válaszokat. Igyekezz, hogy a tőled telhető legjobb módon válaszolj a kérdésekre, hiszen számunkra ez tükrözi leginkább a személyiségedet. A jelentkezési lap kitöltése nem vesz igénybe 5 percnél több időt, ezért semmi értelme gyorsan összecsapni és túllenni rajta. Ne feledd, akár a jelentkezésed is múlhat rajta!\n',
                            style: Theme.of(context).textTheme.bodyText2,
                            textAlign: TextAlign.center),
                        SelectableText(
                            'A jelenkezés időtartama: Szeptember 2.-5.\n',
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.center),
                        SelectableText(
                            'Amennyiben a jelentkezési határidőn belül küldted be a jelentkezési lapot, a határidő lejárta után a rendszer egy e-mail üzenetet fog küldeni a jelentkezés megerősítéséről. Fontos, hogy olyan e-mail címet adj meg, melyet naponta figyelemmel kísérsz!\n\nA személyes elbeszélgetés időpontját a rendszer az előbb említett e-mail üzenetben küldi meg. Előzetesen a személyes beszélgetés várható időpontja: szeptember 7. Az elbeszélgetés minden esetben a délutáni órákban, tanítás után történik.\n',
                            style: Theme.of(context).textTheme.bodyText2,
                            textAlign: TextAlign.center),
                        SelectableText(
                            'A jelentkezéshez sok sikert kívánunk!\n',
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.center),
                        Container(
                          width: fieldWidth(),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: applicationData.namectrl,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                    ),
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    labelText: "Teljes név"),
                              ),
                              Container(
                                height: 24,
                              ),
                              TextFormField(
                                controller: applicationData.classctrl,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                    ),
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    labelText: "Osztály"),
                              ),
                              Container(
                                height: 24,
                              ),
                              TextFormField(
                                controller: applicationData.datectrl,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                    ),
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    labelText: "Születési dátum"),
                              ),
                              Container(
                                height: 24,
                              ),
                              TextFormField(
                                controller: applicationData.telctrl,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                    ),
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    labelText: "Telefonszám"),
                              ),
                              Container(
                                height: 24,
                              ),
                              TextFormField(
                                controller: applicationData.emailctrl,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                    ),
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    labelText: "Email cím"),
                              ),
                              Container(
                                height: 24,
                              ),
                              TextFormField(
                                controller: applicationData.timectrl,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                    ),
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    labelText: "Beutazási idő"),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: SelectableText(
                                    '\nMely tevékenységek érdekelnek Téged?\n',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                    textAlign: TextAlign.center),
                              ),
                              CheckboxListTile(
                                  title: Text("Hangosítás"),
                                  value: applicationData.soundch,
                                  onChanged: (v) {
                                    setState(() {
                                      applicationData.soundch = v;
                                    });
                                  }),
                              CheckboxListTile(
                                  title: Text("Videózás, videóvágás"),
                                  value: applicationData.videoch,
                                  onChanged: (v) {
                                    setState(() {
                                      applicationData.videoch = v;
                                    });
                                  }),
                              CheckboxListTile(
                                  title: Text("Fotózás, képszerkesztés"),
                                  value: applicationData.photoch,
                                  onChanged: (v) {
                                    setState(() {
                                      applicationData.photoch = v;
                                    });
                                  }),
                              CheckboxListTile(
                                  title: Text("DJ, Fénytechnika"),
                                  value: applicationData.djch,
                                  onChanged: (v) {
                                    setState(() {
                                      applicationData.djch = v;
                                    });
                                  }),
                              Container(
                                height: 24,
                              ),
                              TextFormField(
                                controller: applicationData.practicectrl,
                                maxLines: null,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                    ),
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    labelText:
                                        "Van bármilyen gyakorlatod a fentebb választott tevékenységekben?"),
                              ),
                              Container(
                                height: 24,
                              ),
                              TextFormField(
                                controller: applicationData.reasonctrl,
                                maxLines: null,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                    ),
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    labelText:
                                        "Miért szeretnél a VMG Stúdió csapatának tagja lenni?"),
                              ),
                              Container(
                                height: 24,
                              ),
                              TextFormField(
                                controller: applicationData.oosctrl,
                                maxLines: null,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                    ),
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    labelText:
                                        "Van bármilyen iskolán kívüli elfoglaltságod?"),
                              ),
                              Container(
                                height: 24,
                              ),
                              TextFormField(
                                controller: applicationData.posnegctrl,
                                maxLines: null,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                    ),
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    labelText:
                                        "Írj magadról 3 pozitív és 3 negatív tulajdonságot!"),
                              ),
                              Container(
                                height: 24,
                              ),
                              TextFormField(
                                controller: applicationData.otherctrl,
                                maxLines: null,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0.0),
                                    ),
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    labelText: "Megjegyzés"),
                              ),
                              Container(
                                height: 24,
                              ),
                              OutlineButton(
                                borderSide: BorderSide(color: Colors.grey),
                                onPressed: () {
                                  applicationData.upload();
                                },
                                child: Text(
                                  'BEKÜLDÉS',
                                  style: Theme.of(context).textTheme.button,
                                ),
                              ),
                              Container(
                                height: 24,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ApplicationData {
  TextEditingController namectrl = new TextEditingController(text: "");
  TextEditingController classctrl = new TextEditingController(text: "");
  TextEditingController datectrl = new TextEditingController(text: "");
  TextEditingController telctrl = new TextEditingController(text: "");
  TextEditingController emailctrl = new TextEditingController(text: "");
  TextEditingController timectrl = new TextEditingController(text: "");
  bool soundch = false;
  bool videoch = false;
  bool photoch = false;
  bool djch = false;
  TextEditingController practicectrl = new TextEditingController(text: "");
  TextEditingController reasonctrl = new TextEditingController(text: "");
  TextEditingController oosctrl = new TextEditingController(text: "");
  TextEditingController posnegctrl = new TextEditingController(text: "");
  TextEditingController otherctrl = new TextEditingController(text: "");

  Map<String, dynamic> toJson() => {
        'name': namectrl.text,
        'class': classctrl.text,
        'birthdate': datectrl.text,
        'tel': telctrl.text,
        'email': emailctrl.text,
        'traveltime': timectrl.text,
        'issound': soundch.toString(),
        'isvideo': videoch.toString(),
        'isphoto': photoch.toString(),
        'isdj': djch.toString(),
        'practice': practicectrl.text,
        'reason': reasonctrl.text,
        'activities': oosctrl.text,
        'posandneg': posnegctrl.text,
        'comment': otherctrl.text,
      };

  Future<dynamic> upload() async {
    var url = 'https://vmg-studio.hu/api';
    var response = await http.post(url, body: this.toJson());
    print(response.body);
  }
}
