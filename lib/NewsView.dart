import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Newsview extends StatefulWidget {
  
  String url;
  Newsview(this.url);

  @override
  _NewsviewState createState() => _NewsviewState();
}

class _NewsviewState extends State<Newsview> {
  final Completer<WebViewController> controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News View"),
      ),
      body: Container(
        child: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController  WebViewController){
            setState(() {
              controller.complete(WebViewController);
            });
          },
        ),
      ),
    );
  }
}