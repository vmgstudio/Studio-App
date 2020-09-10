import 'package:flutter/material.dart';
import 'functions.dart';
import 'main.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDetailsPage extends StatefulWidget {
  final int dbid;
  UserDetailsPage(this.dbid);
  @override
  _UserDetailsPageState createState() => _UserDetailsPageState(dbid);
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final int dbid;
  _UserDetailsPageState(this.dbid);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Részletek')),
      body: Center(
        child: FutureBuilder(
            future: fetchuserdetails(dbid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                UserDetailsData user = snapshot.data;
                TextEditingController _namectrl =
                    TextEditingController(text: user.name);
                TextEditingController _telctrl =
                    TextEditingController(text: user.tel);
                TextEditingController _emailctrl =
                    TextEditingController(text: user.email);
                TextEditingController _eventsctrl =
                    TextEditingController(text: user.events.join('\n'));
                return SingleChildScrollView(
                  child: Card(
                      color: cardcolor1dp,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.account_circle,
                              color: Colors.white,
                              size: 200,
                            ),
                            TextFormField(
                              controller: _namectrl,
                              textAlign: TextAlign.center,
                              enabled: false,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: cardcolor2dp,
                                border: OutlineInputBorder(),
                                labelText: 'Név',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                launch('tel:' + user.tel);
                              },
                              child: Container(
                                child: TextFormField(
                                  controller: _telctrl,
                                  textAlign: TextAlign.center,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: cardcolor2dp,
                                    border: OutlineInputBorder(),
                                    labelText: 'Telefonszám',
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                launch('mailto:' + user.email);
                              },
                              child: TextFormField(
                                controller: _emailctrl,
                                textAlign: TextAlign.center,
                                enabled: false,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: cardcolor2dp,
                                  border: OutlineInputBorder(),
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _eventsctrl,
                              textAlign: TextAlign.center,
                              enabled: false,
                              maxLines: null,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: cardcolor2dp,
                                border: OutlineInputBorder(),
                                labelText: 'Események',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                );
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
