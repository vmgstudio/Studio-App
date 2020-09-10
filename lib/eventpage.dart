import 'package:flutter/material.dart';
import 'package:studio_flutter/eventdetailspage.dart';
import 'functions.dart';
import 'main.dart';

List<Events> events;

class EventPage extends StatefulWidget {
  @override
  EventPageState createState() => EventPageState();
}

class EventPageState extends State<EventPage> {
  EventPageState() {
    eventaddedDone.listen((event) {
      if (mounted) {
        setState(() {
          _futureevents = fetcheventdata();
          _futureevents.then((value) {
            events = value;
          });
        });
      }
    });
  }
  Future<List<Events>> _futureevents;
  @override
  Widget initState() {
    _futureevents = fetcheventdata();
    _futureevents.then((value) {
      events = value;
    });
  }

  Color _subbuttoncolor(bool _issubbed) {
    if (_issubbed) {
      return Color.fromARGB(255, 0, 143, 38);
    } else {
      return cardcolor2dp;
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
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
          child: Hero(
            tag: events[index].dbid,
            child: MaterialButton(
                onPressed: () {
                  events[index].subscribing = true;
                  setState(() {});
                  Future<SubscribeData> _sub = subscribe(events[index].dbid);
                  _sub.then((value) {
                    Future<List<Events>> _updated = fetcheventdata();
                    _updated.then((value) {
                      events = value;
                      events[index].subscribing = false;
                      setState(() {});
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
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: _futureevents,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return RefreshIndicator(
                  onRefresh: () {
                    setState(() {
                      _futureevents = fetcheventdata();
                      _futureevents.then((value) {
                        events = value;
                      });
                    });
                  },
                  child: ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      Events thisitem = events[index];

                      return Container(
                          height: 91,
                          child: Card(
                            elevation: 1,
                            color: cardcolor1dp,
                            child: InkWell(
                                onTap: () {
                                  if (!thisitem.subscribing) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                EventDetailsPage(index,
                                                    subchanged: () {
                                                  setState(() {});
                                                })));
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            height: 16,
                                            child: Text(
                                              thisitem.name,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                            height: 51,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Text(
                                              thisitem.details,
                                              
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            eventdate(thisitem.date),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Container(
                                            height: 3,
                                          ),
                                          subbutton(
                                              thisitem.isSubscribed, index),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          ));
                    },
                  ));
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
