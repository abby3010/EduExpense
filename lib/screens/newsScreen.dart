import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsScreen extends StatelessWidget {
  NewsScreen({this.url});
  final url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News Feed"),
        centerTitle: true,
      ),
      body: WebView(
        initialUrl: this.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
