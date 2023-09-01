// ignore_for_file: depend_on_referenced_packages, file_names

import 'package:flutter/material.dart';
import 'package:wink30/utils/MyColors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TradingViewWidget extends StatelessWidget {
  final String widgetCode;

  const TradingViewWidget(
      {Key? key,
        required this.widgetCode,
        required Null Function(dynamic controller) onWebViewCreated,
        required String initialUrl})
      : super(key: key);





  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://flutter.dev'));

    return

      WebViewWidget(controller: controller);


    /*WebView(
      backgroundColor: MyColors.bgColor,
      initialUrl: 'about:blank',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        // Load the TradingView widget code when the WebView is created
        webViewController.loadUrl(Uri.dataFromString(
          'widgetCode',
          mimeType: 'text/html',
        ).toString());
      },
    );*/
  }
}
