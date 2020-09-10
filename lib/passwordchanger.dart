import 'package:flutter/material.dart';
import 'functions.dart';
import 'main.dart';

class PasswordChangerPage extends StatefulWidget {
  final bool ispoppable;

  PasswordChangerPage(this.ispoppable);
  @override
  _PasswordChangerPageState createState() =>
      _PasswordChangerPageState(ispoppable);
}

class _PasswordChangerPageState extends State<PasswordChangerPage> {
  final bool ispoppable;
  bool isloading = false;
  _PasswordChangerPageState(this.ispoppable);
  AppBar bar() {
    return AppBar(
      title: Text("Jelszó megváltoztatása"),
    );
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController _oldpassctrl = new TextEditingController();
  TextEditingController _newpass1ctrl = new TextEditingController();
  TextEditingController _newpass2ctrl = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (!ispoppable) {
      _oldpassctrl.text = '1';
    }
    return WillPopScope(
      onWillPop: () {
        if (ispoppable == true) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: bar(),
        body: Builder(builder: (BuildContext context) {
          return Stack(
            children: [
              Visibility(
                visible: !isloading,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'A jelszó nem lehet üres';
                            }
                            return null;
                          },
                          controller: _oldpassctrl,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: cardcolor2dp,
                            border: OutlineInputBorder(),
                            labelText: 'Régi jelszó',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        TextFormField(
                          obscureText: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'A jelszó nem lehet üres';
                            }
                            return null;
                          },
                          controller: _newpass1ctrl,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: cardcolor2dp,
                            border: OutlineInputBorder(),
                            labelText: 'Új jelszó',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        TextFormField(
                          obscureText: true,
                          controller: _newpass2ctrl,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'A jelszó nem lehet üres';
                            }
                            if (_newpass1ctrl.text != _newpass2ctrl.text) {
                              return 'A jelszavak nem egyeznek';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: cardcolor2dp,
                            border: OutlineInputBorder(),
                            labelText: 'Új jelszó megerősítése',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                isloading = true;
                              });
                              Future<DeleteItemData> chpwd = changepassword(
                                  _oldpassctrl.text, _newpass2ctrl.text);
                              chpwd.then((value) async {
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text(value.message)));
                                await new Future.delayed(
                                    const Duration(seconds: 2));
                                setState(() {
                                  isloading = false;
                                });
                                Navigator.of(context).pop();
                              });
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.save,
                                  color: Colors.white,
                                ),
                                Text(
                                  " Mentés",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          color: customblue,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(visible: isloading, child: Center(child: CircularProgressIndicator(),),)
            ],
          );
        }),
      ),
    );
  }
}
