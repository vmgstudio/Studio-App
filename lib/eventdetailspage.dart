import 'package:flutter/material.dart';
import 'functions.dart';
import 'main.dart';
import 'eventpage.dart';
import 'eventsubspage.dart';
import 'eventeditorpage.dart';

class EventDetailsPage extends StatefulWidget {
  int thisevent;
  final VoidCallback subchanged;
  EventDetailsPage(int _events, {this.subchanged}) {
    thisevent = _events;
  }

  @override
  _EventDetailsPageState createState() =>
      _EventDetailsPageState(thisevent, subcb: () {
        subchanged();
      });
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final VoidCallback subcb;
  Events thisevent;
  int eventindex;
  bool _isloading = false;

  String monthconvert(int month) {
    if (month == 1) {
      return "JAN";
    } else if (month == 2) {
      return "FEB";
    } else if (month == 3) {
      return "MÁRC";
    } else if (month == 11) {
      return "NOV";
    } else if (month == 5) {
      return "MÁJ";
    } else if (month == 6) {
      return "JÚN";
    } else if (month == 7) {
      return "JÚL";
    } else if (month == 8) {
      return "AUG";
    } else if (month == 9) {
      return "SZEPT";
    } else if (month == 10) {
      return "OKT";
    } else if (month == 12) {
      return "DEC";
    } else if (month == 4) {
      return "ÁPR";
    }
  }

  String eventdate(String date) {
    DateTime parsed = DateTime.parse(date);
    return parsed.year.toString() +
        " " +
        monthconvert(parsed.month) +
        " " +
        parsed.day.toString();
  }

  Color _subbuttoncolor(bool _issubbed) {
    if (_issubbed) {
      return Color.fromARGB(255, 56, 142, 60);
    } else {
      return cardcolor2dp;
    }
  }

  List<Color> _appbarcolor() {
    if (events[eventindex].subscribing) {
      return <Color>[customblue, Color.fromRGBO(0, 113, 188, 90)];
    } else if (events[eventindex].isSubscribed) {
      return <Color>[
        Color.fromARGB(255, 56, 142, 60),
        Color.fromARGB(155, 56, 142, 60)
      ];
    } else if (!events[eventindex].isSubscribed) {
      return <Color>[Colors.white24, Colors.white10];
    }
  }

  String _subbutontext(bool _issubbed, int index) {
    if (_issubbed) {
      return "Leiratkozás " +
          events[index].currentSubs.toString() +
          "/" +
          events[index].maxSubs.toString();
    } else {
      return "Feliratkozás " +
          events[index].currentSubs.toString() +
          "/" +
          events[index].maxSubs.toString();
    }
  }

  Widget subbutton(bool _issubbed, int index) {
    if (!events[index].subscribing) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Hero(
            tag: events[eventindex].dbid,
            child: MaterialButton(
                onPressed: () {
                  _isloading = true;
                  events[index].subscribing = true;
                  setState(() {});
                  Future<SubscribeData> _sub = subscribe(events[index].dbid);
                  _sub.then((value) {
                    Future<List<Events>> _updated = fetcheventdata();
                    _updated.then((value) {
                      events = value;
                      events[index].subscribing = false;
                      thisevent = value[index];
                      subcb();
                      _isloading = false;
                      if (mounted) {
                        setState(() {});
                      }
                    });
                  });
                },
                color: _subbuttoncolor(_issubbed),
                child: Text(
                  _subbutontext(_issubbed, index),
                  style: TextStyle(color: Colors.white, fontSize: 12),
                )),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: MaterialButton(
              onPressed: () {},
              color: customblue,
              child: Text(
                _subbutontext(_issubbed, index),
                style: TextStyle(color: Colors.white, fontSize: 12),
              )),
        ),
      );
    }
  }

  FloatingActionButton fab() {
    if (isadmin) {
      return FloatingActionButton(
        heroTag: 'edit',
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => EventEditorPage(
                        eventindex,
                        updated: () {
                          Future<List<Events>> _updated = fetcheventdata();
                          _updated.then((value) {
                            events = value;
                            events[eventindex].subscribing = false;
                            thisevent = value[eventindex];
                            subcb();
                            _isloading = false;
                            if (mounted) {
                              setState(() {});
                            }
                          });
                        },
                      )));
        },
        backgroundColor: customblue,
        child: Icon(Icons.edit),
      );
    }
  }

  _EventDetailsPageState(int index, {this.subcb}) {
    thisevent = events[index];
    eventindex = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: AppBar(
          backgroundColor: Colors.black,
          bottom: PreferredSize(
              child: Visibility(
                  visible: _isloading,
                  child: LinearProgressIndicator(value: null)),
              preferredSize: Size.fromHeight(0)),
          flexibleSpace: Stack(children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: _appbarcolor(),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(72, 0, 0, 24),
                child: Text(
                  thisevent.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ]),
          title: Text('Esemény részletei'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: fab(),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Card(
            color: cardcolor1dp,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  subbutton(thisevent.isSubscribed, eventindex),
                  Text(
                    eventdate(thisevent.date),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(height: 10),
                  Text(thisevent.details),
                  Hero(
                    tag: 'subs',
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      child: Text(
                        'Feliratkozók',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: cardcolor2dp,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    EventSubsPage(eventindex)));
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
