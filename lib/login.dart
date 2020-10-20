import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:studio_web/main.dart';

Color cardcolor1dp = Colors.grey[900];

class LoginDialog extends StatelessWidget {
  LoginData data = new LoginData();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Center(
          child: LoginWidget(
        data: data,
      )),
    );
  }
}

class LoginWidget extends StatefulWidget {
  final LoginData data;

  const LoginWidget({Key key, this.data}) : super(key: key);
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370,
      child: Card(
        color: cardcolor1dp,
        elevation: 1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      'Bejelentkezés',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    splashRadius: 25,
                    hoverColor: Colors.grey[800],
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: widget.data.usernamectrl,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: Colors.white),
                    autocorrect: false,
                    obscureText: false,
                    textInputAction: TextInputAction.next,
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
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: Colors.white),
                      controller: widget.data.passwordctrl,
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        fillColor: cardcolor1dp,
                        filled: true,
                        border: OutlineInputBorder(),
                        errorText: widget.data.error,
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 191, 191, 191),
                        ),
                        prefixIcon: Icon(Icons.lock,
                            color: Color.fromARGB(255, 191, 191, 191)),
                      ),
                    ),
                  ),
                  MaterialButton(
                    hoverColor: Colors.grey[800],
                    onPressed: () {
                      widget.data.error = null;
                      widget.data.isloading = true;
                      setState(() {});
                      UserData.login(widget.data.usernamectrl.text,
                              widget.data.passwordctrl.text)
                          .then((value) {
                        if (value != "") {
                          widget.data.error = value;
                        }
                        widget.data.isloading = false;
                        if (mounted) {
                          setState(() {});
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: widget.data.isloading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [CircularProgressIndicator()],
                            )
                          : Row(
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginData {
  String error;
  bool isloading = false;
  TextEditingController usernamectrl = new TextEditingController(text: '');
  TextEditingController passwordctrl = new TextEditingController(text: '');

  Map<String, dynamic> toJson() =>
      {"username": usernamectrl.text, "passwordhash": passwordctrl.text};
}

String hash(String input) {
  List<int> bytes = utf8.encode(input);
  String hash = sha256.convert(bytes).toString();
  return hash;
}
