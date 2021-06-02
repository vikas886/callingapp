import 'dart:async';

// ignore: import_of_legacy_library_into_null_safe
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import './call.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();
  static const adUnitId = "ca-app-pub-3265867824196947/6098547793";

  /// if channel textField is validated to have error
  bool _validateError = false;
  final AdSize adSize = AdSize(width: 300, height: 50);
  ClientRole _role = ClientRole.Broadcaster;

  final BannerAd myBanner = BannerAd(
    adUnitId: adUnitId,
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    myBanner.load();
  }

  final BannerAdListener listener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );
  @override
  Widget build(BuildContext context) {
    final AdWidget adWidget = AdWidget(ad: myBanner);
    final Container adContainer = Container(
      alignment: Alignment.center,
      child: adWidget,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Calling App'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 400,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    controller: _channelController,
                    decoration: InputDecoration(
                      errorText:
                          _validateError ? 'Channel name is mandatory' : null,
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                      hintText: 'Channel name',
                    ),
                  ))
                ],
              ),
              // Column(
              //   children: [
              //     ListTile(
              //       title: Text(ClientRole.Broadcaster.toString()),
              //       leading: Radio(
              //         value: ClientRole.Broadcaster,
              //         groupValue: _role,
              //         onChanged: (ClientRole value) {
              //           setState(() {
              //             _role =ClientRole.Broadcaster;
              //           });
              //         },
              //       ),
              //     ),
              //     ListTile(
              //       title: Text(ClientRole.Audience.toString()),
              //       leading: Radio(
              //         value: ClientRole.Audience,
              //         groupValue: _role,
              //         onChanged: (ClientRole value) {
              //           setState(() {
              //             _role = value;
              //           });
              //         },
              //       ),
              //     )
              //   ],
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        onPressed: onJoin,
                        child: Text('Get Started'),
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              adContainer,
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    // update input validation
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (_channelController.text.isNotEmpty) {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      // push video page with given channel name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(_channelController.text, _role),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
