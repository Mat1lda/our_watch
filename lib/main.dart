import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:out_watch/Pages/main_page.dart';
import './Pages/splash_page.dart';

void main() {
  runApp(SplashPage(
    key: UniqueKey(),
    onInitializationComplete: () => runApp(ProviderScope(child: MyApp())),//dung providerscope cua river pod, sau do dung comsumer widget de dung dc watch quan ly state
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "OurWatch",
      initialRoute: "home",
      routes: {"home": (BuildContext context) => MainPage()},
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity),
    );
  }
}
