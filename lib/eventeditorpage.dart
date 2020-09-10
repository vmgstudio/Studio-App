//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'functions.dart';
import 'main.dart';
import 'eventpage.dart';
import 'eventdetailspage.dart';
import 'package:intl/intl.dart';

class EventEditorPage extends StatefulWidget {
  final int eventindex;
  final VoidCallback updated;
  EventEditorPage(this.eventindex, {this.updated});
  @override
  _EventEditorPageState createState() => _EventEditorPageState(eventindex, saved: () {updated();});
}

class _EventEditorPageState extends State<EventEditorPage> {
  final _page = GlobalKey<ScaffoldState>();
  final VoidCallback saved;
  final int eindex;
  final titlectrl = TextEditingController();
  final detailsctrl = TextEditingController();
  final subsctrl = TextEditingController();
  bool isloading = false;
  DateTime selectedDate;

  String formatDate(DateTime date) =>
      new DateFormat("yyyy. MM. dd.").format(date);

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  _EventEditorPageState(this.eindex, {this.saved}) {
    titlectrl.text = events[eindex].name;
    detailsctrl.text = events[eindex].details;
    subsctrl.text = events[eindex].maxSubs.toString();
    selectedDate = DateTime.parse(events[eindex].date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _page,
      appBar: AppBar(title: Text('Esemény szerkesztése')),
      body: Hero(
        tag: 'edit',
        child: Stack(
          children: <Widget>[
            Visibility(
              visible: !isloading,
              child: SingleChildScrollView(
                child: Card(
                  color: cardcolor1dp,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: titlectrl,
                          autocorrect: false,
                          obscureText: false,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: cardcolor2dp,
                              border: OutlineInputBorder(),
                              labelText: 'Esemény címe',
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              prefixIcon: Icon(
                                Icons.title,
                                color: Colors.white,
                              )),
                        ),
                        Container(height: 10),
                        MaterialButton(
                          elevation: 2,
                          color: cardcolor2dp,
                          onPressed: () {
                            _selectDate(context);
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.calendar_today, color: Colors.white),
                                Text(
                                  '  Esemény dátuma: ' +
                                      formatDate(selectedDate),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(height: 10),
                        TextFormField(
                          controller: subsctrl,
                          autocorrect: false,
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: cardcolor2dp,
                              border: OutlineInputBorder(),
                              labelText: 'Vállalók',
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              prefixIcon: Icon(
                                Icons.filter_9_plus,
                                color: Colors.white,
                              )),
                        ),
                        Container(height: 10),
                        TextFormField(
                          controller: detailsctrl,
                          autocorrect: false,
                          obscureText: false,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: cardcolor2dp,
                              border: OutlineInputBorder(),
                              labelText: 'Esemény részletei',
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              prefixIcon: Icon(
                                Icons.format_align_justify,
                                color: Colors.white,
                              )),
                        ),
                        Container(height: 10),
                        MaterialButton(
                          elevation: 2,
                          color: customblue,
                          onPressed: () {
                            setState(() {
                              isloading = true;
                            });
                            Future<DeleteItemData> save = updateevent(
                                events[eindex].dbid,
                                titlectrl.text,
                                subsctrl.text,
                                detailsctrl.text,
                                selectedDate);
                            save.then((value) async {
                              SnackBar snackBar =
                                  SnackBar(content: Text(value.message));
                              _page.currentState.showSnackBar(snackBar);
                              await new Future.delayed(
                                  const Duration(seconds: 1));
                                  saved();
                              setState(() {
                                
                                isloading = false;
                                Navigator.pop(context);
                              });
                            });
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width ,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(
                                    Icons.save,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    'Mentés',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
                visible: isloading,
                child: Center(child: CircularProgressIndicator())),
          ],
        ),
      ),
    );
  }
}
