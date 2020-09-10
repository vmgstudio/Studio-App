import 'package:flutter/material.dart';
import 'functions.dart';
import 'main.dart';

class DiallerPage extends StatefulWidget {
  @override
  _DiallerPageState createState() => _DiallerPageState();
}

class _DiallerPageState extends State<DiallerPage> {
  TextEditingController _dialctrl = new TextEditingController(text: '');
  bool _isloading = false;

  void bntpress(String number) {
    _dialctrl.text = _dialctrl.text + number;
    if (_dialctrl.text.length == 7) {
      Future<ScanData> dial = dialled(_dialctrl.text);
      _isloading = true;
      setState(() {});
      dial.then((value) {
        SnackBar snackBar = SnackBar(content: Text(value.message));
        page.currentState.showSnackBar(snackBar);
      }).catchError((error, ctx) {
        SnackBar snackBar = SnackBar(content: Text(error));
        page.currentState.showSnackBar(snackBar);
      }).whenComplete(() {
        _isloading = false;
        _dialctrl.text = '';
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: !_isloading,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFormField(
                  controller: _dialctrl,
                  textAlign: TextAlign.center,
                  enabled: false,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: cardcolor2dp,
                    border: OutlineInputBorder(),
                    labelText: 'Eszközkód',
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  height: 8,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    // child: GridView.count(
                    //   primary: false,
                    //   padding: const EdgeInsets.all(30),
                    //   crossAxisSpacing: 10,
                    //   mainAxisSpacing: 10,
                    //   crossAxisCount: 3,
                    //   children: <Widget>[
                    //     ClipOval(
                    //       child: Container(
                    //         height: 50,
                    //         width: 50,
                    //         child: MaterialButton(
                    //           onPressed: () {
                    //             bntpress('1');
                    //           },
                    //           child: Text(
                    //             '1',
                    //             style: TextStyle(
                    //                 fontSize: 30, color: Colors.white),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     ClipOval(
                    //       child: Container(
                    //         height: 50,
                    //         width: 50,
                    //         child: MaterialButton(
                    //           onPressed: () {
                    //             bntpress('2');
                    //           },
                    //           child: Text(
                    //             '2',
                    //             style: TextStyle(
                    //                 fontSize: 30, color: Colors.white),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     ClipOval(
                    //       child: Container(
                    //         height: 50,
                    //         width: 50,
                    //         child: MaterialButton(
                    //           onPressed: () {
                    //             bntpress('3');
                    //           },
                    //           child: Text(
                    //             '3',
                    //             style: TextStyle(
                    //                 fontSize: 30, color: Colors.white),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     ClipOval(
                    //       child: Container(
                    //         height: 50,
                    //         width: 50,
                    //         child: MaterialButton(
                    //           onPressed: () {
                    //             bntpress('4');
                    //           },
                    //           child: Text(
                    //             '4',
                    //             style: TextStyle(
                    //                 fontSize: 30, color: Colors.white),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     ClipOval(
                    //       child: Container(
                    //         height: 50,
                    //         width: 50,
                    //         child: MaterialButton(
                    //           onPressed: () {
                    //             bntpress('5');
                    //           },
                    //           child: Text(
                    //             '5',
                    //             style: TextStyle(
                    //                 fontSize: 30, color: Colors.white),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     ClipOval(
                    //       child: Container(
                    //         height: 50,
                    //         width: 50,
                    //         child: MaterialButton(
                    //           onPressed: () {
                    //             bntpress('6');
                    //           },
                    //           child: Text(
                    //             '6',
                    //             style: TextStyle(
                    //                 fontSize: 30, color: Colors.white),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     ClipOval(
                    //       child: Container(
                    //         height: 50,
                    //         width: 50,
                    //         child: MaterialButton(
                    //           onPressed: () {
                    //             bntpress('7');
                    //           },
                    //           child: Text(
                    //             '7',
                    //             style: TextStyle(
                    //                 fontSize: 30, color: Colors.white),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     ClipOval(
                    //       child: Container(
                    //         height: 50,
                    //         width: 50,
                    //         child: MaterialButton(
                    //           onPressed: () {
                    //             bntpress('8');
                    //           },
                    //           child: Text(
                    //             '8',
                    //             style: TextStyle(
                    //                 fontSize: 30, color: Colors.white),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     ClipOval(
                    //       child: Container(
                    //         height: 50,
                    //         width: 50,
                    //         child: MaterialButton(
                    //           onPressed: () {
                    //             bntpress('9');
                    //           },
                    //           child: Text(
                    //             '9',
                    //             style: TextStyle(
                    //                 fontSize: 30, color: Colors.white),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     ClipOval(
                    //       child: Container(
                    //         height: 50,
                    //         width: 50,
                    //         child: MaterialButton(
                    //           onPressed: () {
                    //             _dialctrl.text = '';
                    //           },
                    //           child: Icon(Icons.delete,
                    //               size: 30, color: Colors.white),
                    //         ),
                    //       ),
                    //     ),
                    //     ClipOval(
                    //       child: Container(
                    //         height: 50,
                    //         width: 50,
                    //         child: MaterialButton(
                    //           onPressed: () {
                    //             bntpress('0');
                    //           },
                    //           child: Text(
                    //             '0',
                    //             style: TextStyle(
                    //                 fontSize: 30, color: Colors.white),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     ClipOval(
                    //       child: Container(
                    //         height: 50,
                    //         width: 50,
                    //         child: MaterialButton(
                    //           onPressed: () {
                    //             if (_dialctrl.text != '') {
                    //               _dialctrl.text = _dialctrl.text
                    //                   .substring(0, _dialctrl.text.length - 1);
                    //             }
                    //           },
                    //           child: Icon(Icons.backspace,
                    //               size: 30, color: Colors.white),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Table(
                        children: [
                          TableRow(children: [
                            ClipOval(
                              child: Container(
                                height: 100,
                                width: 100,
                                child: MaterialButton(
                                  onPressed: () {
                                    bntpress('1');
                                  },
                                  child: Text(
                                    '1',
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            ClipOval(
                              child: Container(
                                height: 100,
                                width: 100,
                                child: MaterialButton(
                                  onPressed: () {
                                    bntpress('2');
                                  },
                                  child: Text(
                                    '2',
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            ClipOval(
                              child: Container(
                                height: 100,
                                width: 100,
                                child: MaterialButton(
                                  onPressed: () {
                                    bntpress('3');
                                  },
                                  child: Text(
                                    '3',
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            ClipOval(
                              child: Container(
                                height: 100,
                                width: 100,
                                child: MaterialButton(
                                  onPressed: () {
                                    bntpress('4');
                                  },
                                  child: Text(
                                    '4',
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            ClipOval(
                              child: Container(
                                height: 100,
                                width: 100,
                                child: MaterialButton(
                                  onPressed: () {
                                    bntpress('5');
                                  },
                                  child: Text(
                                    '5',
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            ClipOval(
                              child: Container(
                                height: 100,
                                width: 100,
                                child: MaterialButton(
                                  onPressed: () {
                                    bntpress('6');
                                  },
                                  child: Text(
                                    '6',
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            ClipOval(
                              child: Container(
                                height: 100,
                                width: 100,
                                child: MaterialButton(
                                  onPressed: () {
                                    bntpress('7');
                                  },
                                  child: Text(
                                    '7',
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            ClipOval(
                              child: Container(
                                height: 100,
                                width: 100,
                                child: MaterialButton(
                                  onPressed: () {
                                    bntpress('8');
                                  },
                                  child: Text(
                                    '8',
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            ClipOval(
                              child: Container(
                                height: 100,
                                width: 100,
                                child: MaterialButton(
                                  onPressed: () {
                                    bntpress('9');
                                  },
                                  child: Text(
                                    '9',
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                          TableRow(
                            children: [
                              ClipOval(
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  child: MaterialButton(
                                    onPressed: () {
                                      _dialctrl.text = '';
                                    },
                                    child: Icon(Icons.delete,
                                        size: 30, color: Colors.white),
                                  ),
                                ),
                              ),
                              ClipOval(
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  child: MaterialButton(
                                    onPressed: () {
                                      bntpress('0');
                                    },
                                    child: Text(
                                      '0',
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              ClipOval(
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  child: MaterialButton(
                                    onPressed: () {
                                      if (_dialctrl.text != '') {
                                        _dialctrl.text = _dialctrl.text.substring(
                                            0, _dialctrl.text.length - 1);
                                      }
                                    },
                                    child: Icon(Icons.backspace,
                                        size: 30, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: _isloading,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
      ],
    );
  }
}
