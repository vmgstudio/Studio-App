import 'package:flutter/material.dart';
import 'functions.dart';
import 'main.dart';
import 'eventpage.dart';
import 'eventdetailspage.dart';
import 'package:intl/intl.dart';

class EventNewPage extends StatefulWidget {
  final VoidCallback update;
  EventNewPage({this.update});

  @override
  _EventNewPageState createState() => _EventNewPageState(updated: () {
        update();
        print('updated');
      });
}

class _EventNewPageState extends State<EventNewPage> {
  final VoidCallback updated;
  _EventNewPageState({this.updated});

  DateTime selectedDate = DateTime.now();
  String _titletext = '';
  String _detailstext = '';
  String _maxsubstext = '';
  bool isloading = false;
  final _page = GlobalKey<ScaffoldState>();

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
                          autocorrect: false,
                          obscureText: false,
                          onChanged: (text) {
                            _titletext = text;
                          },
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
                          autocorrect: false,
                          obscureText: false,
                          onChanged: (text) {
                            _maxsubstext = text;
                          },
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
                          autocorrect: false,
                          obscureText: false,
                          onChanged: (text) {
                            _detailstext = text;
                          },
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
                            Future<DeleteItemData> save = addevent(_titletext,
                                _maxsubstext, _detailstext, selectedDate);
                            save.then((value) async {
                              SnackBar snackBar =
                                  SnackBar(content: Text(value.message));
                              _page.currentState.showSnackBar(snackBar);
                              await new Future.delayed(
                                  const Duration(seconds: 1));
                              setState(() {
                                updated();
                                isloading = false;
                                Navigator.pop(context);
                              });
                            });
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width - 2,
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
