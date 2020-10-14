import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studio_web/login.dart';
import 'application.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mysql1/mysql1.dart' as MySQL;

import 'homepage.dart';

void main() {
  runApp(new HotRestartController(child: MyApp()));
  UserData.readPrefs();
}

class Consts {
  static int mobileWidth = 1000;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'VMG Stúdió',
        theme: ThemeData(
          unselectedWidgetColor: Colors.white,
          textTheme: TextTheme(
            headline1: GoogleFonts.nunito(
                fontSize: 102,
                fontWeight: FontWeight.w300,
                letterSpacing: -1.5,
                color: Color.fromARGB(255, 240, 240, 240)),
            headline2: GoogleFonts.nunito(
                fontSize: 64,
                fontWeight: FontWeight.w300,
                letterSpacing: -0.5,
                color: Color.fromARGB(255, 240, 240, 240)),
            headline3: GoogleFonts.nunito(
                fontSize: 51,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 240, 240, 240)),
            headline4: GoogleFonts.nunito(
                fontSize: 36,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.25,
                color: Color.fromARGB(255, 240, 240, 240)),
            headline5: GoogleFonts.nunito(
                fontSize: 25,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 240, 240, 240)),
            headline6: GoogleFonts.nunito(
                fontSize: 21,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.15,
                color: Color.fromARGB(255, 240, 240, 240)),
            subtitle1: GoogleFonts.nunito(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.15,
                color: Color.fromARGB(255, 240, 240, 240)),
            subtitle2: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                color: Color.fromARGB(255, 240, 240, 240)),
            bodyText1: GoogleFonts.nunito(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
                color: Color.fromARGB(255, 240, 240, 240)),
            bodyText2: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.25,
                color: Color.fromARGB(255, 240, 240, 240)),
            button: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.25,
                color: Color.fromARGB(255, 240, 240, 240)),
            caption: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.4,
                color: Color.fromARGB(255, 240, 240, 240)),
            overline: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.5,
                color: Color.fromARGB(255, 240, 240, 240)),
          ),
          canvasColor: Color.fromARGB(255, 18, 18, 18),
          primarySwatch: Colors.grey,
        ),
/*       routes: {
        '/': (context) => HomePage(),
        '/application': (context) => ApplicationPage(),
        
      },
 */
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case "/application":
              return PageRouteBuilder(
                pageBuilder: (_, __, ___) => ApplicationPage(),
                transitionDuration: Duration(milliseconds: 0),
                transitionsBuilder: (_, anim, __, child) {
                  return FadeTransition(opacity: anim, child: child);
                },
              );
              break;
            case "/":
              return PageRouteBuilder(
                pageBuilder: (_, __, ___) => HomePage(),
                transitionDuration: Duration(milliseconds: 0),
                transitionsBuilder: (_, anim, __, child) {
                  return FadeTransition(opacity: anim, child: child);
                },
              );
              break;
          }
        });
  }
}

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width + 1 > Consts.mobileWidth) {
      if (!UserData.isloggedin) {
        return Hero(
          tag: "topbar",
          child: Container(
            color: Colors.grey[900],
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Image.asset(
                  'assets/studiologo_90.png',
                  width: 50,
                  height: 50,
                ),
                FlatButton(
                  hoverColor: Colors.grey[850],
                  splashColor: Colors.grey[500],
                  highlightColor: Colors.grey[800],
                  onPressed: () {
                    Navigator.popAndPushNamed(
                      context,
                      '/',
                    );
                  },
                  child: Text(
                    "VMG STÚDIÓ",
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(fontSize: 20, color: Colors.white),
                  ),
                ),
                Container(
                  width: 16,
                ),
                FlatButton(
                  hoverColor: Colors.grey[850],
                  splashColor: Colors.grey[500],
                  highlightColor: Colors.grey[800],
                  onPressed: () {
                    if (!UserData.isloggedin) {
                      Navigator.popAndPushNamed(
                        context,
                        '/',
                      );
                    }
                  },
                  child: Text(
                    "FŐOLDAL",
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Colors.white),
                  ),
                ),
                FlatButton(
                  hoverColor: Colors.grey[850],
                  splashColor: Colors.grey[500],
                  highlightColor: Colors.grey[800],
                  onPressed: () {
                    Navigator.popAndPushNamed(
                      context,
                      '/application',
                    );
                  },
                  child: Text(
                    "JELENTKEZÉS",
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      hoverColor: Colors.grey[850],
                      splashColor: Colors.grey[500],
                      highlightColor: Colors.grey[800],
                      onPressed: () {
                        Navigator.popAndPushNamed(
                          context,
                          '/',
                        );
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => LoginDialog());
                      },
                      child: Text(
                        "BEJELENTKEZÉS",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return Hero(
          tag: "topbar",
          child: Container(
            color: Colors.grey[900],
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Image.asset(
                  'assets/studiologo_90.png',
                  width: 50,
                  height: 50,
                ),
                FlatButton(
                  hoverColor: Colors.grey[850],
                  splashColor: Colors.grey[500],
                  highlightColor: Colors.grey[800],
                  onPressed: () {
                    Navigator.popAndPushNamed(
                      context,
                      '/',
                    );
                  },
                  child: Text(
                    "VMG STÚDIÓ",
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(fontSize: 20, color: Colors.white),
                  ),
                ),
                Container(
                  width: 16,
                ),
                FlatButton(
                  hoverColor: Colors.grey[850],
                  splashColor: Colors.grey[500],
                  highlightColor: Colors.grey[800],
                  onPressed: () {
                    Navigator.popAndPushNamed(
                      context,
                      '/',
                    );
                  },
                  child: Text(
                    "FŐOLDAL",
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      hoverColor: Colors.grey[850],
                      splashColor: Colors.grey[500],
                      highlightColor: Colors.grey[800],
                      onPressed: () {
                        Navigator.popAndPushNamed(
                          context,
                          '/',
                        );
                        UserData.logout();
                      },
                      child: Text(
                        "KIJELENTKEZÉS",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } else
      return Container(
        width: 0,
        height: 0,
      );
  }
}

class MobileAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String title;

  MobileAppBar(
    this.title, {
    Key key,
  })  : preferredSize = Size.fromHeight(56.0),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < Consts.mobileWidth) {
      return AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.grey[900],
        title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: Colors.white),
        ),
        automaticallyImplyLeading: true,
      );
    } else
      return Container(
        width: 0,
        height: 0,
      );
  }
}

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < Consts.mobileWidth) {
      if (!UserData.isloggedin) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.grey[900]),
                child: Image.asset('assets/studiologo.png'),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.popAndPushNamed(context, "/");
                },
                leading: Icon(Icons.home, color: Colors.white),
                title: Text('Főoldal'),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.popAndPushNamed(context, "/application");
                },
                leading: Icon(Icons.note_add, color: Colors.white),
                title: Text('Jelentkezés'),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.popAndPushNamed(
                    context,
                    '/',
                  );
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => LoginDialog());
                },
                leading: Icon(Icons.lock, color: Colors.white),
                title: Text('Bejelentkezés'),
              ),
            ],
          ),
        );
      } else {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.grey[900]),
                child: Image.asset('assets/studiologo.png'),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.popAndPushNamed(context, "/");
                },
                leading: Icon(Icons.home, color: Colors.white),
                title: Text('Főoldal'),
              ),
              ListTile(
                onTap: () {
                  Navigator.popAndPushNamed(
                    context,
                    '/',
                  );
                  UserData.logout();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => LoginDialog());
                },
                leading: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                title: Text('Kijelentkezés'),
              ),
            ],
          ),
        );
      }
    } else
      return Container(
        width: 0,
        height: 0,
      );
  }
}

class UserData {
  static BuildContext context;
  static bool isloggedin = false;
  static String userid;
  static String username;
  static String apikey;
  static bool admin;
  static String apiV;
  static String apiurl = "https://vmg-studio.hu/api/api.php";

  static void readPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserData.apikey = prefs.getString('apikey') ?? "";
    UserData.userid = prefs.getString('userid') ?? "";
    validate();
  }

  static void writePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userid', userid);
    prefs.setString('apikey', apikey);
  }

  static void logout() {
    username = "";
    apikey = "";
    userid = "";
    admin = false;
    apiV = "";
    isloggedin = false;
    HotRestartController.performHotRestart(context);
  }

  static void validate() async {
    if (userid != "" || apikey != "") {
      final response = await http.get(apiurl +
          "?action=validateUserCredentials&key=" +
          apikey +
          "&uid=" +
          userid);
      if (response.statusCode == 200) {
        var j = json.decode(response.body);
        username = j['name'];
        admin = (j['admin'] == 1);
        apiV = j['api_version'];
        Response r = Response(status: j['status'], message: j['message']);
        isloggedin = r.status;
        print(isloggedin);
        HotRestartController.performHotRestart(context);
      }
    }
  }

  static void login(String uid, String pwd) async {
    final response = await http.get(apiurl +
        "?action=requestUIDvalidation&uid=" +
        uid +
        "&password=" +
        pwd);
    if (response.statusCode == 200) {
      var j = json.decode(response.body);
      apikey = j['api_key'];
      userid = j['user_id'].toString();
      Response r = Response(status: j['status'], message: j['message']);
      if (r.status) {
        writePrefs();
        validate();
      }
    }
  }
}

class Response {
  bool status;
  String message;

  Response({this.status, this.message});

  Response.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class HotRestartController extends StatefulWidget {
  final Widget child;

  HotRestartController({this.child});

  static performHotRestart(BuildContext context) {
    final _HotRestartControllerState state = context
        .ancestorStateOfType(const TypeMatcher<_HotRestartControllerState>());
    state.performHotRestart();
  }

  @override
  _HotRestartControllerState createState() => new _HotRestartControllerState();
}

class _HotRestartControllerState extends State<HotRestartController> {
  Key key = new UniqueKey();

  void performHotRestart() {
    this.setState(() {
      key = new UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      key: key,
      child: widget.child,
    );
  }
}
