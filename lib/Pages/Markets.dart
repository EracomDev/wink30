// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:wink30/utils/MyColors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Markets extends StatefulWidget {
  const Markets({Key? key}) : super(key: key);

  @override
  _MarketsState createState() => _MarketsState();
}

class _MarketsState extends State<Markets> {
  bool isLoading = true;

  var controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.bgColor,
      body: Stack(
        children: [

          if (isLoading)
            Container(
              color: MyColors.bgColor,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),

          if(!isLoading)
            WebViewWidget(controller: controller,),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print(progress);

            if(progress==100){


              /*setState(() {
              _isLoading = false;
            });*/
            }
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {

            setState(() {
              isLoading = false;
            });

          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://gambitbot.io/graph'));
    super.initState();
  }
}
