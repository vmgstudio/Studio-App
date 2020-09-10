import 'package:flutter/material.dart';
import 'functions.dart';
import 'main.dart';
import 'dart:html';
import "dart:ui" as ui;

class WebScannerPage extends StatefulWidget {
  @override
  _WebScannerPageState createState() => _WebScannerPageState();
}

class _WebScannerPageState extends State<WebScannerPage> {
  @override
  Widget build(BuildContext context) {
    final IFrameElement _iframeElement = IFrameElement();
    _iframeElement.height = '500';
    _iframeElement.width = '500';
    _iframeElement.src = "https://vmg-studio.hu/v2/scan.html?key=" + apiKey;
    //_iframeElement.src = "https://index.hu/";
    _iframeElement.style.border = 'none';

    //ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iframeElement,
    );
    Widget _iframeWidget;
    _iframeWidget = HtmlElementView(
      key: UniqueKey(),
      viewType: 'iframeElement',
    );

    return Scaffold(
      appBar: AppBar(backgroundColor: customblue, title: Text('Beolvasás'),),
      body: Stack(
        children: <Widget>[
          IgnorePointer(
            ignoring: true,
            child: Center(
              child: _iframeWidget,
            ),
          ),
          AbsorbPointer(
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
