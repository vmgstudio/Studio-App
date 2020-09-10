import 'package:flutter/material.dart';
import 'functions.dart';
import 'main.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Future<List<ApiItem>> _historyitems;
  List<ApiItem> items;
  List<ApiItem> filtered;

  @override
  Widget initState() {
    _historyitems = fetchhistory();
    _historyitems.then((value) {
      filtered = value;
      items = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    String _historyname(ApiItem item) {
      if (item.pending) {
        return "⏳" + item.name;
      } else {
        return item.name;
      }
    }

    return Container(
      child: FutureBuilder(
          future: _historyitems,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: <Widget>[
                  Card(
                    color: cardcolor1dp,
                    elevation: 1,
                    child: TextFormField(
                      onChanged: (text) {
                        setState(() {
                          if (text == '') {
                            filtered = items;
                          } else {
                            filtered = new List<ApiItem>();
                            for (var item in items) {
                              if (item.name.toLowerCase().contains(text.toLowerCase()) ||
                                  item.name.contains(text.toLowerCase())) {
                                filtered.add(item);
                              }
                            }
                          }
                        });
                      },
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.white70,
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Szűrés',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 191, 191, 191),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      elevation: 1,
                      color: cardcolor1dp,
                      child: RefreshIndicator(
                        onRefresh: () {
                          setState(() {
                            _historyitems = fetchhistory();
                            _historyitems.then((value) {
                              filtered = value;
                              items = value;
                            });
                          });
                        },
                        child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(
                            color: Color.fromARGB(255, 120, 120, 120),
                            height: 1,
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            ApiItem thisitem = filtered[index];
                            return ListTile(
                                onTap: () {},
                                title: Text(_historyname(thisitem)),
                                dense: true,
                                isThreeLine: true,
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          thisitem.username,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          width: 0,
                                          height: 8,
                                        ),
                                        Text(
                                          thisitem.dept,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      thisitem.datetime,
                                    ),
                                  ],
                                ));
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
