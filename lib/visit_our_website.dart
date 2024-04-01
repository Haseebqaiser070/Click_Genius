import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:link_shortener/colors.dart';

class VisitOurWebsite extends StatefulWidget {
  const VisitOurWebsite({Key? key}) : super(key: key);

  @override
  _VisitOurWebsiteState createState() => _VisitOurWebsiteState();
}

class _VisitOurWebsiteState extends State<VisitOurWebsite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purpleBlue,
        centerTitle: true,
        title: const Text('Click Genius'),
      ),
      body: WebView(
        initialUrl: 'https://click-genius.com/',
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
