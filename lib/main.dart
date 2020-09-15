import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
//import 'dart:ui' as ui;
import 'package:studio_flutter/diallerpage.dart';
import 'package:studio_flutter/homepage.dart';
import 'package:studio_flutter/newnotipage.dart';
import 'package:studio_flutter/passwordchanger.dart';
//import 'package:studio_flutter/webscannerpage.dart';
import 'profilepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'eventnewpage.dart';
import 'functions.dart';
import 'historypage.dart';
import 'eventpage.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'userslist.dart';

final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
void main() {
  runApp(MyApp());
}

StreamController eventadded = new StreamController.broadcast();
Stream get eventaddedDone => eventadded.stream;
StreamController onmessagectrl = new StreamController.broadcast();
Stream get onmessagectrlDone => onmessagectrl.stream;

String version = "5.8.2";
Color cardcolor1dp = Color.fromARGB(255, 29, 29, 29);
Color cardcolor2dp = Color.fromARGB(255, 33, 33, 33);
MaterialColor customblue = MaterialColor(0xFF0071bc, {
  50: Color.fromRGBO(0, 113, 188, .1),
  100: Color.fromRGBO(0, 113, 188, .2),
  200: Color.fromRGBO(0, 113, 188, .3),
  300: Color.fromRGBO(0, 113, 188, .4),
  400: Color.fromRGBO(0, 113, 188, .5),
  500: Color.fromRGBO(0, 113, 188, .6),
  600: Color.fromRGBO(0, 113, 188, .7),
  700: Color.fromRGBO(0, 113, 188, .8),
  800: Color.fromRGBO(0, 113, 188, .9),
  900: Color.fromRGBO(0, 113, 188, 1),
});
String useridTextfield = '';
String passwordTextfield = '';
int selectedyear = 0;
List<String> schoolyears = ['2020-2021'];
EventPage eventPage = new EventPage();
final page = GlobalKey<ScaffoldState>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stúdió',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.

          primarySwatch: customblue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
          canvasColor: Color.fromARGB(255, 18, 18, 18),
          textTheme: Typography.whiteHelsinki),
      home: MyHomePage(title: 'Stúdió'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key) {
    if (!kIsWeb) {
      firebaseMessaging.setAutoInitEnabled(true);
      firebaseMessaging.subscribeToTopic('global');
      firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> message) async {
        print(message);
        SnackBar snackBar = SnackBar(
            content: Text(
                'Értesítés érkezett! További információ a főoldalon')); //frissíteni a főoldalt+ kiolvasni azt hogy mi a cím és kiírni
        page.currentState.showSnackBar(snackBar);
        onmessagectrl.add('message');
      });
    }
  }
  final String title;
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<MyHomePage> {
  int stateid = 1;
  final focus = FocusNode();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  var qrText = "";
  QRViewController controller;

  void updatestate(id) {
    if (id == 4 && kIsWeb == true) {
      //Navigator.push(
      //  context,
      //MaterialPageRoute(
      //  builder: (BuildContext context) => WebScannerPage()));
    } else {
      stateid = id;
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void loginerror() {
    updatestate(0);
  }

  FutureBuilder itempage() {
    Future<List<ApiItem>> _myapiitems;
    _myapiitems = myitems();

    return FutureBuilder(
        future: _myapiitems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return RefreshIndicator(
              onRefresh: () {
                setState(() {});
              },
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) => Divider(
                  color: Color.fromARGB(255, 120, 120, 120),
                  height: 1,
                ),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  ApiItem thisitem = snapshot.data[index];
                  return InkWell(
                    onTap: () {},
                    child: ListTile(
                        title: Text(thisitem.name),
                        dense: true,
                        trailing: InkWell(
                            onTap: () {
                              _itemclickeddialog(thisitem.dbid, thisitem.name);
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            )),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              thisitem.dept,
                            ),
                            Text(
                              thisitem.datetime,
                            ),
                          ],
                        )),
                  );
                },
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Future<void> _itemclickeddialog(String dbid, String name) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 18, 18, 18),
          title: Text('Eszköz visszaadása'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Biztosan vissza akarod adni a következő eszközt: ' +
                    name +
                    '?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Mégse'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                Future<DeleteItemData> _delete = deleteitemfuture(dbid);
                _delete.then((value) {
                  SnackBar snackBar = SnackBar(content: Text(value.message));
                  page.currentState.showSnackBar(snackBar);
                  setState(() {});
                }).catchError((error, stacktrace) {
                  SnackBar snackBar = SnackBar(content: Text(error));
                  page.currentState.showSnackBar(snackBar);
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget drawer() {
    if (isadmin) {
      return ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: customblue[500],
              ),
              child: Image.asset('assets/studiologo_transparent.png'),
            ),
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                  updatestate(2);
                },
                child: ListTile(
                  leading: Icon(Icons.home, color: Colors.white),
                  title: Text('Főoldal'),
                )),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                updatestate(3);
              },
              child: ListTile(
                leading: Icon(Icons.list, color: Colors.white),
                title: Text('Saját tárgyak'),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                updatestate(4);
              },
              child: ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.white),
                title: Text('Beolvasás'),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                updatestate(8);
              },
              child: ListTile(
                leading: Icon(Icons.library_books, color: Colors.white),
                title: Text('Napló'),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                updatestate(5);
              },
              child: ListTile(
                leading: Icon(Icons.calendar_today, color: Colors.white),
                title: Text('Eseménynaptár'),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                updatestate(9);
              },
              child: ListTile(
                leading: Icon(Icons.add_box, color: Colors.white),
                title: Text('Új értesítés'),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                updatestate(6);
              },
              child: ListTile(
                leading: Icon(Icons.group, color: Colors.white),
                title: Text('Taglista'),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                updatestate(7);
              },
              child: ListTile(
                leading: Icon(Icons.account_circle, color: Colors.white),
                title: Text('Profil'),
              ),
            ),
            InkWell(
              onTap: () {
                if (!kIsWeb) {
                  firebaseMessaging.deleteInstanceID();
                }
                addStringToSF("userid", '');
                addStringToSF("apikey", "");
                updatestate(0);
              },
              child: ListTile(
                leading: Icon(Icons.power_settings_new, color: Colors.white),
                title: Text('Kijelentkezés'),
              ),
            ),
            ListTile(
              trailing: Text('v ' + version),
              title: Text(name),
            )
          ],
        
      );
    } else {
      return ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: customblue[500],
              ),
              child: Image.asset('assets/studiologo_transparent.png'),
            ),
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                  updatestate(2);
                },
                child: ListTile(
                  leading: Icon(Icons.home, color: Colors.white),
                  title: Text('Főoldal'),
                )),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                updatestate(3);
              },
              child: ListTile(
                leading: Icon(Icons.list, color: Colors.white),
                title: Text('Saját tárgyak'),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                updatestate(4);
              },
              child: ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.white),
                title: Text('Beolvasás'),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                updatestate(5);
              },
              child: ListTile(
                leading: Icon(Icons.calendar_today, color: Colors.white),
                title: Text('Eseménynaptár'),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                updatestate(6);
              },
              child: ListTile(
                leading: Icon(Icons.group, color: Colors.white),
                title: Text('Taglista'),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                updatestate(7);
              },
              child: ListTile(
                leading: Icon(Icons.account_circle, color: Colors.white),
                title: Text('Profil'),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                addStringToSF("userid", '');
                addStringToSF("apikey", "");
                updatestate(0);
              },
              child: ListTile(
                leading: Icon(Icons.power_settings_new, color: Colors.white),
                title: Text('Kijelentkezés'),
              ),
            ),
            ListTile(
              trailing: Text('v ' + version),
              title: Text(name),
            )
          ],
        
      );
    }
  }

  Widget screens() {
    void scanwithdata(ScanData data, QRViewController controller) {
      if (data != null) {
        SnackBar snackBar = SnackBar(content: Text(data.message));
        page.currentState.showSnackBar(snackBar);
      }
    }

    void _onQRViewCreated(QRViewController controller) {
      this.controller = controller;
      controller.scannedDataStream.listen((scanData) {
        setState(() {
          qrText = scanData;
          print(qrText);

          Future<ScanData> scanfinished = scan(qrText);
          scanfinished.then((value) => scanwithdata(value, controller));
        });
      });
    }

    if (stateid == 4) {
      if (kIsWeb) {
      } else {
        return Center(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
            ],
          ),
        );
      }
    } else if (stateid == 3) {
      return Center(
        child: itempage(),
      );
    } else if (stateid == 8) {
      return Center(
        child: HistoryPage(),
      );
    } else if (stateid == 5) {
      return Center(child: eventPage);
    } else if (stateid == 6) {
      return Center(
        child: UserListPage(),
      );
    } else if (stateid == 7) {
      return Center(child: ProfilePage());
    } else if (stateid == 9) {
      return Center(child: NewNotiPage());
    } else if (stateid == 2) {
      return HomePage(
        scanstate: () {
          updatestate(4);
        },
        itemliststate: () {
          updatestate(3);
        },
        diallerstate: () {
          updatestate(10);
        },
      );
    } else if (stateid == 10) {
      return DiallerPage();
    } else {
      return Center(
        child: Text("egyéb gyász"),
      );
    }
  }

  @override
  Widget initState() {
    void _login(bool future) {
      if (future) {
        updatestate(2);
      }
    }

    void credentialsgot(initValidate iv) {
      apiKey = iv.apikey;
      userId = iv.userid;
      Future<ValidateData> validatefuture = validate();
      validatefuture
          .then((value) => _login(value.status))
          .catchError((error, stackTrace) {
        loginerror();
      });
    }

    //belépett e már? => ha igen akkor valide();
    Future<initValidate> credentialsfuture() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String apikey = prefs.getString('apikey') ?? "";
      String userid = prefs.getString('userid') ?? "";
      initValidate returned = new initValidate();
      if (returned.apikey != '' && returned.userid != '') {
        returned.apikey = apikey;
        returned.userid = userid;
        return returned;
      } else {
        updatestate(0);
        throw Exception("No data in storage");
      }
    }

    Future<initValidate> _getcredentials = credentialsfuture();
    _getcredentials
        .then((value) => credentialsgot(value))
        .catchError((error, stackTrace) {});
  }

  Widget fab() {
    if (stateid == 4) {
      if (!kIsWeb) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () {
                controller.toggleFlash();
              },
              backgroundColor: customblue,
              child: Icon(Icons.flash_on),
            ),
            Container(
              width: 0,
              height: 8,
            ),
            FloatingActionButton(
              onPressed: () {
                updatestate(3);
              },
              backgroundColor: customblue,
              child: Icon(Icons.list),
            ),
          ],
        );
      }
    } else if (stateid == 3) {
      return FloatingActionButton(
        onPressed: () {
          updatestate(4);
        },
        backgroundColor: customblue,
        child: Icon(Icons.camera_alt),
      );
    } else if (stateid == 5 && isadmin) {
      return FloatingActionButton(
        heroTag: 'edit',
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => EventNewPage(
                        update: () {
                          print('updated2');
                          eventadded.add("all done");
                        },
                      )));
        },
        backgroundColor: customblue,
        child: Icon(Icons.add),
      );
    } else if (stateid == 7) {
      return FloatingActionButton(
        onPressed: () {
          Future<DeleteItemData> updt = updateuserdetails();
          updt.then((value) {
            SnackBar snackBar = SnackBar(content: Text(value.message));
            page.currentState.showSnackBar(snackBar);
            setState(() {});
          });
        },
        child: Icon(Icons.save),
        backgroundColor: customblue,
      );
    }
  }

  Widget layoutbuilder() {
    return LayoutBuilder(builder: (context, constraints) {
      if (MediaQuery.of(context).size.width < 800) {
        return screens();
      } else
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Flexible(child: drawer()),Flexible(flex: 2, child: screens())]);
    });
  }

  Widget titletext() {
    if (stateid == 2) {
      return Text('Főoldal');
    } else if (stateid == 3) {
      return Text('Saját tárgyak');
    } else if (stateid == 4) {
      return Text('Beolvasás');
    } else if (stateid == 5) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Eseménynaptár'),
          DropdownButton<String>(
            value: schoolyears[selectedyear],
            icon: Icon(
              Icons.arrow_downward,
              color: Colors.white,
            ),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.white),
            underline: Container(
              height: 2,
              color: Colors.white,
            ),
            onChanged: (String newValue) {
              setState(() {
                selectedyear = schoolyears.indexOf(newValue);
                eventadded.add("all done");
              });
            },
            items: schoolyears.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )
        ],
      );
    } else if (stateid == 6) {
      return Text('Taglista');
    } else if (stateid == 7) {
      return Text('Profil');
    } else if (stateid == 8) {
      return Text('Napló');
    } else if (stateid == 9) {
      return Text('Új értesítés');
    } else if (stateid == 10) {
      return Text('Eszközkód beütése');
    }
  }

  Widget build(BuildContext context) {
    if (stateid == 0) {
      return Scaffold(
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              height: 430,
              width: 370,
              child: Card(
                color: cardcolor1dp,
                elevation: 1,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset(
                            'assets/studiologo_transparent.png',
                            width: 150,
                          )),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              autocorrect: false,
                              obscureText: false,
                              onChanged: (text) {
                                useridTextfield = text;
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus);
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: cardcolor1dp,
                                border: OutlineInputBorder(),
                                labelText: 'UserID',
                                labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 191, 191, 191),
                                ),
                                prefixIcon: Icon(Icons.account_circle,
                                    color: Color.fromARGB(255, 191, 191, 191)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                              child: TextFormField(
                                obscureText: true,
                                focusNode: focus,
                                onChanged: (text) {
                                  passwordTextfield = text;
                                },
                                textInputAction: TextInputAction.send,
                                onFieldSubmitted: (text) {
                                  updatestate(1);
                                  Future<LoginData> logindata =
                                      auth(useridTextfield, passwordTextfield);
                                  void _validate() {
                                    void _login(bool future) {
                                      if (future) {
                                        updatestate(2);
                                      }
                                    }

                                    Future<ValidateData> validatefuture =
                                        validate();
                                    validatefuture
                                        .then((value) => _login(value.status))
                                        .catchError((error) {
                                      loginerror();
                                    });
                                  }

                                  logindata
                                      .then((value) => _validate())
                                      .catchError((error, stackTrace) {
                                    loginerror();
                                  });
                                },
                                decoration: InputDecoration(
                                  fillColor: cardcolor1dp,
                                  filled: true,
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 191, 191, 191),
                                  ),
                                  prefixIcon: Icon(Icons.lock,
                                      color:
                                          Color.fromARGB(255, 191, 191, 191)),
                                ),
                              ),
                            ),
                            MaterialButton(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.lock_open,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'Bejelentkezés',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () {
                                updatestate(1);
                                Future<LoginData> logindata =
                                    auth(useridTextfield, passwordTextfield);
                                void _validate() {
                                  void _login(bool future) {
                                    if (future) {
                                      if (passwordTextfield == '1') {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        PasswordChangerPage(
                                                            false)));
                                      }

                                      updatestate(2);
                                    }
                                  }

                                  Future<ValidateData> validatefuture =
                                      validate();
                                  validatefuture.then((value) {
                                    _login(value.status);
                                  }).catchError((error, stacktrace) {
                                    loginerror();
                                  });
                                }

                                logindata
                                    .then((value) => _validate())
                                    .catchError((error, stackTrace) {
                                  loginerror();
                                });
                              },
                              color: customblue,
                            )
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
      );
    } else if (stateid == 1) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 430,
              width: 370,
              child: Card(
                elevation: 1,
                color: cardcolor1dp,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        key: page,
        appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: titletext()),
        drawer: Drawer(child: drawer()),
        //body: screens(),
        body: screens(),
        floatingActionButton: fab(),
      );
    }
  }
}
