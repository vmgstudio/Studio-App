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
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Container(
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
                        controller: data.usernamectrl,
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
                          controller: data.passwordctrl,
                          textInputAction: TextInputAction.send,
                          decoration: InputDecoration(
                            fillColor: cardcolor1dp,
                            filled: true,
                            border: OutlineInputBorder(),
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
                          UserData.login(
                              data.usernamectrl.text, data.passwordctrl.text);
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginData {
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
