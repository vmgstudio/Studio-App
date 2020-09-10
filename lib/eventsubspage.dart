import 'package:flutter/material.dart';
import 'functions.dart';
import 'main.dart';
import 'eventpage.dart';
import 'eventdetailspage.dart';

class EventSubsPage extends StatefulWidget {
  int _eventindex;
  EventSubsPage(int eventid) {
    _eventindex = eventid;
  }
  @override
  _EventSubsPageState createState() => _EventSubsPageState(_eventindex);
}

class _EventSubsPageState extends State<EventSubsPage> {
  int _eventindex;
  bool _isloading = false;
  _EventSubsPageState(int eventid) {
    _eventindex = eventid;
  }

  Widget list() {
    for (var u in apiUsers) {
      int _id = u.dbid;
      u.subbed = false;

      for (var item in events[_eventindex].subscribers) {
        if (item.dbid == _id) {
          u.subbed = true;
        }
      }
    }
    if (!isadmin) {
      return ListView.builder(
          itemCount: events[_eventindex].subscribers.length,
          itemBuilder: (context, index) {
            Subscribers thisitem = events[_eventindex].subscribers[index];
            return ListTile(
              onTap: () {},
              title: Text(thisitem.name),
            );
          });
    } else {
      return ListView.builder(
        itemCount: apiUsers.length,
        itemBuilder: (context, index) {
          Users thisitem = apiUsers[index];
          return CheckboxListTile(
            title: Text(thisitem.name),
            value: thisitem.subbed,
            onChanged: (bool newvalue) {
              setState(() {
                _isloading = true;
              });
              Future<ForceSubData> force = forcesubscription(
                  events[_eventindex].dbid, apiUsers[index].dbid);
              force.then((value) {
                Future<List<Events>> fetch = fetcheventdata();
                fetch.then((value) {
                  events = value;
                  if (mounted) {
                    setState(() {
                      _isloading = false;
                    });
                  }
                });
              });
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Esemény feliratkozói"),
      ),
      body: Hero(
        tag: 'subs',
        child: Column(
          children: <Widget>[
            Visibility(
                visible: _isloading,
                child: LinearProgressIndicator(
                  value: null,
                )),
            Expanded(
              child: Center(
                child: Card(color: cardcolor1dp, child: list()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
