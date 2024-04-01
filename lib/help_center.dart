import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:link_shortener/colors.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({Key? key}) : super(key: key);

  @override
  _HelpCenterState createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purpleBlue,
        centerTitle: true,
        title: const Text('Help Center'),
      ),
      body: WebView(
        initialUrl: 'https://click-genius.com/pages/privacy',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          // _controller.complete(webViewController);
          // final String contentBase64 = base64Encode(
          //     const Utf8Encoder().convert('' "${widget.html!}" ''));
          // webViewController.loadUrl('data:text/html;base64,$contentBase64');
        },
        onProgress: (int progress) {
          print("WebView is loading (progress : $progress%)");
        },
        gestureNavigationEnabled: true,
      ),
    );
  }
}
