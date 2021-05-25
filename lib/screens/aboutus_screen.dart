import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../config/color.dart';
import '../widget/appbar.dart';
import '../widget/loading.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  bool isLoading = true;
  final _key = UniqueKey();

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String initialUrl =
        "https://docs.google.com/viewerng/viewer?url=http://www.semvac.info/adminpanel/aboutus/aboutus.docx";
    return Scaffold(
      appBar: appBar(context),
      backgroundColor: appBackground,
      body: Stack(
        children: [
          WebView(
            key: _key,
            initialUrl: initialUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading
              ? Center(
                  child: kLoadingWidget(context),
                )
              : Stack(),
        ],
      ),
    );
  }
}
