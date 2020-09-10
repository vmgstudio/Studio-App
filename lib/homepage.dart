import 'package:flutter/material.dart';
import 'package:studio_flutter/notilist.dart';
import 'functions.dart';
import 'main.dart';
import 'eventpage.dart';
import 'eventdetailspage.dart';

class HomePage extends StatefulWidget {
  final VoidCallback scanstate;
  final VoidCallback itemliststate;
  final VoidCallback diallerstate;

  const HomePage(
      {Key key, this.scanstate, this.itemliststate, this.diallerstate})
      : super(key: key);
  @override
  _HomePageState createState() => _HomePageState(scanstate: () {
        scanstate();
      }, itemliststate: () {
        itemliststate();
      }, diallerstate: () {
        diallerstate();
      });
}

class _HomePageState extends State<HomePage> {
  final VoidCallback scanstate;
  final VoidCallback itemliststate;
  final VoidCallback diallerstate;
  HomeData homeData;
  Future<List<Events>> _futureevents;
  Future<HomeData> home;
  int index = 0;
  bool isdatanull = false;

  _HomePageState({this.scanstate, this.diallerstate, this.itemliststate});
  @override
  Widget initState() {
    super.initState();
    Future<List<SchoolYears>> yrs = fetchyeardata();
    yrs.then((value) {
      schoolyears.clear();
      for (var i = 0; i < value.length; i++) {
        schoolyears.add(value[i].label);
      }
      selectedyear = schoolyears.length -1;
    });
    _futureevents = fetcheventdata();
    _futureevents.then((value) {
      events = value;
      home = fetchhomedata();
      home.then((value) {
        homeData = value;
        int _i = 0;
        if (homeData.event != null) {
          for (var item in events) {
            if (homeData.event.dbid == item.dbid) {
              index = _i;
            }
            _i = _i + 1;
          }
          isdatanull = false;
        } else {
          homeData.event = Events(
              name: "Nincsenek események rögzítve a közeljövőben",
              details: "",
              date: "2020-01-01",
              subscribers: List<Subscribers>(),
              currentSubs: 0,
              maxSubs: 0,
              isSubscribed: false);
          isdatanull = true;
        }
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    onmessagectrlDone.listen((event) {
      if (mounted) {
        Future<HomeData> home = fetchhomedata();
        home.then((value) {
          homeData = value;
          if (mounted) {
            setState(() {});
          }
        });
      }
    });

    return FutureBuilder(
        future: home,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
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
                            Future<SubscribeData> _sub =
                                subscribe(events[index].dbid);
                            _sub.then((value) {
                              Future<List<Events>> _updated = fetcheventdata();
                              _updated.then((value) {
                                events = value;
                                events[index].subscribing = false;
                                home = fetchhomedata();
                                home.then((value) {
                                  homeData = value;
                                  int _i = 0;
                                  if (homeData.event != null) {
                                    for (var item in events) {
                                      if (homeData.event.dbid == item.dbid) {
                                        index = _i;
                                      }
                                      _i = _i + 1;
                                    }
                                    isdatanull = false;
                                  } else {
                                    homeData.event = Events(
                                        name:
                                            "Nincsenek események rögzítve a közeljövőben",
                                        details: "",
                                        date: "2020-01-01",
                                        subscribers: List<Subscribers>(),
                                        currentSubs: 0,
                                        maxSubs: 0,
                                        isSubscribed: false);
                                    isdatanull = true;
                                  }
                                  setState(() {});
                                });
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

            return RefreshIndicator(
              onRefresh: () {
                _futureevents = fetcheventdata();
                _futureevents.then((value) {
                  events = value;
                  home = fetchhomedata();
                  home.then((value) {
                    homeData = value;
                    int _i = 0;
                    if (homeData.event != null) {
                      for (var item in events) {
                        if (homeData.event.dbid == item.dbid) {
                          index = _i;
                        }
                        _i = _i + 1;
                      }
                      isdatanull = false;
                    } else {
                      homeData.event = Events(
                          name: "Nincsenek események rögzítve a közeljövőben",
                          details: "",
                          date: "2020-01-01",
                          subscribers: List<Subscribers>(),
                          currentSubs: 0,
                          maxSubs: 0,
                          isSubscribed: false);
                      isdatanull = true;
                    }
                    setState(() {});
                  });
                });
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 91,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        elevation: 1,
                        color: cardcolor1dp,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  scanstate();
                                },
                                color: customblue,
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  child: Icon(Icons.camera_alt,
                                      color: Colors.white),
                                ),
                              ),
                              Container(
                                width: 8,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  itemliststate();
                                },
                                color: customblue,
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  child:
                                      Icon(Icons.delete, color: Colors.white),
                                ),
                              ),
                              Container(
                                width: 8,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  diallerstate();
                                },
                                color: customblue,
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  child:
                                      Icon(Icons.dialpad, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                        height: 91,
                        child: Card(
                          elevation: 1,
                          color: cardcolor1dp,
                          child: InkWell(
                              onTap: () {
                                if (!isdatanull) {
                                  if (!homeData.event.subscribing) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                EventDetailsPage(index,
                                                    subchanged: () {
                                                  home = fetchhomedata();
                                                  home.then((value) {
                                                    homeData = value;
                                                    int _i = 0;
                                                    if (homeData.event !=
                                                        null) {
                                                      for (var item in events) {
                                                        if (homeData
                                                                .event.dbid ==
                                                            item.dbid) {
                                                          index = _i;
                                                        }
                                                        _i = _i + 1;
                                                      }
                                                    }
                                                    setState(() {});
                                                  });
                                                })));
                                  }
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Icon(
                                      Icons.event,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    Container(width: 8),
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
                                            homeData.event.name,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          height: 51,
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4 *
                                                  2.2 -
                                              8,
                                          child: Text(
                                            homeData.event.details,
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          eventdate(homeData.event.date),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Container(
                                          height: 3,
                                        ),
                                        subbutton(
                                            homeData.event.isSubscribed, index),
                                      ],
                                    )
                                  ],
                                ),
                              )),
                        )),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Hero(
                        tag: "notipage",
                        child: Card(
                          elevation: 1,
                          color: cardcolor1dp,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          NotiListPage(
                                            posts: homeData.posts,
                                          )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  Container(width: 8),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        homeData.posts[0].title,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Container(height: 4),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                70,
                                        child: Text(
                                          homeData.posts[0].message,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 91,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        elevation: 1,
                        color: cardcolor1dp,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.account_circle,
                                color: Colors.white,
                                size: 24,
                              ),
                              Container(width: 8),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(homeData.name + " - " + homeData.group),
                                ],
                              ),
                              Spacer(),
                              Text(homeData.subs.toString() + "/10")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
