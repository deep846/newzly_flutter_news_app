import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsView extends StatefulWidget {
  final String url;
  NewsView(this.url,);
  @override
  _NewsViewState createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  late String finalurl;
  final Completer<WebViewController> controller = Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
    if(widget.url.toString().contains("http://"))
    {
      finalurl = widget.url.toString().replaceAll("http://", "https://");
    }
    else{
      finalurl = widget.url;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Newzly"),
        centerTitle: true,
      ),
      body: Container(
        child: WebView(
          initialUrl: finalurl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webviewController){
            setState(() {
              controller.complete(webviewController);
            });
          },
        ),
      ),
    );
  }
}
