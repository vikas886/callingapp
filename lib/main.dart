import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:calling_app/home_page.dart';
import './src/pages/index.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.

        primarySwatch: Colors.amber,
      ),
      // home: HomePage(),
      home: IndexPage(),
    );
  }
}
