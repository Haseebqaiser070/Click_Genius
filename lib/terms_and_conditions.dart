import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:link_shortener/colors.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purpleBlue,
        centerTitle: true,
        title: const Text('Terms and Conditions'),
      ),
      body: WebView(
        initialUrl: 'https://click-genius.com/pages/terms',
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
