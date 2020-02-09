import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class How extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'How it works?'
        ),
      ),
      body: WebView(
        initialUrl: 'https://sharetime.in/how',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
