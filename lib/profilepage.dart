import 'package:flutter/material.dart';
import 'package:studio_flutter/passwordchanger.dart';
import 'functions.dart';
import 'main.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

TextEditingController namectrl;
TextEditingController telctrl;
TextEditingController emailctrl;

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchuserdetails(int.parse(userId)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          UserDetailsData user = snapshot.data;
          namectrl = TextEditingController(text: user.name);
          telctrl = TextEditingController(text: user.tel);
          emailctrl = TextEditingController(text: user.email);
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
                      FlatButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PasswordChangerPage(true)));}, child: Text('Jelszóváltoztatás', style: TextStyle(color: Colors.white),)),
                      TextFormField(
                        controller: namectrl,
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
                      TextFormField(
                        controller: telctrl,
                        textAlign: TextAlign.center,
                        enabled: true,
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
                      TextFormField(
                        controller: emailctrl,
                        textAlign: TextAlign.center,
                        enabled: true,
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
      },
    );
  }
}
