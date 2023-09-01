import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/MyColors.dart';

class InviteFriendPage extends StatefulWidget {
  String userId;
  InviteFriendPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<InviteFriendPage> createState() => _InviteFriendPageState();
}

class _InviteFriendPageState extends State<InviteFriendPage> {
  late var size;

  String walletId = "";
  String linkUrl = "";
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: MyColors.bgColor, // <-- SEE HERE
          statusBarIconBrightness:
              Brightness.light, //<-- For Android SEE HERE (dark icons)
          statusBarBrightness:
              Brightness.light, //<-- For iOS SEE HERE (dark icons)
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: MyColors.bgColor,
        title: const Text(
          "Invite Friends",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.normal, color: Colors.white),
        ),
        titleSpacing: 0,
        elevation: 0,
        //automaticallyImplyLeading: false,
        //brightness: Brightness.light,
        //brightness: Brightness.light,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                color: MyColors.bgColor,
                height: 200,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    elevation: 2,
                    color: MyColors.bgColor.withOpacity(1),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      constraints: BoxConstraints(
                          minWidth: size.width * .7,
                          maxWidth: size.width * .85),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(

                          // color: Colors.white.withOpacity(.2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          border:
                              Border.all(color: MyColors.textColor, width: 2)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "My Referral Id : ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              const Spacer(),
                              Text(
                                widget.userId,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.withOpacity(.2)),
                            child: QrImageView(

                                //data: "IDsdfsdghbvghgtyhbgsdt4gfgsdfg......",
                                //data: "https://apk.aavelend.eu/index?ref="+walletId,
                                data: linkUrl,
                                version: QrVersions.auto,
                                foregroundColor: Colors.white,
                                // bgColorColor: MyColors.primary.withOpacity(.5),
                                size: 200.0,
                                gapless: true,
                                eyeStyle: const QrEyeStyle(
                                  eyeShape: QrEyeShape.circle,
                                  color: Colors.white,
                                ),
                                dataModuleStyle: const QrDataModuleStyle(
                                  dataModuleShape: QrDataModuleShape.circle,
                                  color: Colors.black,
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Use the scanner to bind the invitation relationship.",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              InkWell(
                                child: Container(
                                  constraints:
                                      BoxConstraints(minWidth: size.width * .3),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  decoration: BoxDecoration(
                                      color: MyColors.primaryColor,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: const Text(
                                    "Share Link",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                onTap: () async {
                                  final RenderBox box =
                                      context.findRenderObject() as RenderBox;
                                  String shareText =
                                      "Hi, Use Wink30 to refer your friends for Referral benefits. \n So don't delay. Join Wink30 today Here is the link: " +
                                          linkUrl.toString();

                                  //final bytes = await rootBundle.load('assets/images/footer_banner.png');
                                  // final tempDir = await getTemporaryDirectory();
                                  // final file = await File('${tempDir.path}/image.jpg').create();
                                  // file.writeAsBytesSync(list);

                                  //var url = 'https://i.ytimg.com/vi/fq4N0hgOWzU/maxresdefault.jpg';
                                  /* var response = await get(Uri.parse(bottomBanner));
                              final documentDirectory = (await getExternalStorageDirectory())!.path;
                              File imgFile = new File('$documentDirectory/flutter.png');
                              imgFile.writeAsBytesSync(response.bodyBytes);*/
                                  //final list = bytes.buffer.asUint8List();

                                  // Share.shareFiles(['$documentDirectory/flutter.png'], text: '$shareText',subject: "Referral Link",);

                                  await Share.share(shareText,
                                      subject: "Referral Link",
                                      sharePositionOrigin:
                                          box.localToGlobal(Offset.zero) &
                                              box.size);
                                },
                              ),
                              const Spacer(),
                              InkWell(
                                child: Container(
                                  constraints:
                                      BoxConstraints(minWidth: size.width * .3),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  decoration: BoxDecoration(
                                      color: MyColors.primaryColor,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: const Text(
                                    "Copy Link",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                onTap: () async {
                                  Clipboard.setData(
                                      ClipboardData(text: linkUrl.toString()));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Link copied successfully.'),
                                  ));
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Text(
                        "Warm reminder invite friends to bind ID account you can get the invitation income of your friend investment.",
                        style: TextStyle(fontSize: 12),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState

    fetchPref();
    super.initState();
  }

  fetchPref() async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String addressStr = prefs.getString("walletAddress").toString();
    setState(() {
      walletId = addressStr;
    });

    showDialog(
        barrierDismissible: false,
        barrierColor: const Color(0x56030303),
        context: context,
        builder: (_) => const Material(
              type: MaterialType.transparency,
              child: Center(
                // Aligns the container to center
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Please wait....",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ));

    //String link = "https://fintoch.page.link/?link=https://aavelend.eu/&apn=com.era.fintoch&";

    String DynamicLink = 'https://wink30.com/?referral_id=' + widget.userId;

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://wink30.page.link',
      link: Uri.parse(DynamicLink),
      androidParameters: const AndroidParameters(
        packageName: 'com.era.wink30',
        minimumVersion: 0,
        //fallbackUrl: Uri.parse('https://aavelend.eu/'),
      ),
      iosParameters: const IOSParameters(
        bundleId: 'io.invertase.testing',
        minimumVersion: '0',
      ),
    );

    Uri url;
    if (true) {
      final ShortDynamicLink shortLink =
          await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {}

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    setState(() {
      linkUrl = url.toString();
    });

    print(url);
  }
}
