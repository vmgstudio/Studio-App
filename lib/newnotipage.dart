import 'package:flutter/material.dart';
import 'functions.dart';
import 'main.dart';

class NewNotiPage extends StatefulWidget {
  @override
  _NewNotiPageState createState() => _NewNotiPageState();
}

class _NewNotiPageState extends State<NewNotiPage> {
  TextEditingController _titlectrl = new TextEditingController();
  TextEditingController _msgctrl = new TextEditingController();
  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardcolor1dp,
      child: Stack(
        children: [
          Visibility(
            visible: !_isloading,
            child: Column(
              children: [
                TextFormField(
                  autocorrect: false,
                  obscureText: false,
                  controller: _titlectrl,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: cardcolor2dp,
                      border: OutlineInputBorder(),
                      labelText: 'Értesítés címe',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      prefixIcon: Icon(
                        Icons.title,
                        color: Colors.white,
                      )),
                ),
                Container(height: 10),
                TextFormField(
                  autocorrect: false,
                  obscureText: false,
                  controller: _msgctrl,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: cardcolor2dp,
                      border: OutlineInputBorder(),
                      labelText: 'Értesítés szövege',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      prefixIcon: Icon(
                        Icons.format_align_justify,
                        color: Colors.white,
                      )),
                ),
                Container(height: 10),
                MaterialButton(
                  elevation: 2,
                  color: customblue,
                  onPressed: () {
                    setState(() {
                      _isloading = true;
                    });
                    Future<DeleteItemData> send =
                        sendnewnoti(_titlectrl.text, _msgctrl.text);
                    send.then((value) {
                      SnackBar snackBar =
                          SnackBar(content: Text(value.message));
                      page.currentState.showSnackBar(snackBar);
                       if(mounted) {setState(() {
                         _titlectrl.text = "";
                         _msgctrl.text = "";
                      _isloading = false;
                    });}
                    });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 2,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                          Text(
                            'Küldés',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
              visible: _isloading,
              child: Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }
}
