import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:out_watch/model/config.dart';
import 'package:out_watch/service/http_service.dart';
import 'package:out_watch/service/movie_service.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback
      onInitializationComplete; //function which takes no parameters and returns no parameters

  const SplashPage({super.key, required this.onInitializationComplete});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2)).then(
      (_) => setup(context).then(
        (_) => widget.onInitializationComplete(),
      ),
    );
    super.initState();
  }

//loading up data, json, set up service
  Future<void> setup(BuildContext context) async {
    final getIt = GetIt.instance;
    final configFile =
        await rootBundle.loadString("assets/config/main.json"); //upload json
    final configData = jsonDecode(
        configFile); //giải mã chuỗi JSON, bây giờ nó sẽ là một đối tượng Dart (thường là Map<String, dynamic>)
    getIt.registerSingleton<AppConfig>(
      AppConfig(configData["BASE_API_URL"], configData["BASE_IMAGE_API_URL"],
          configData["API_KEY"]),
    );
    getIt.registerSingleton<HTTPService>(
      HTTPService(),
    );
    getIt.registerSingleton<MovieService>(
    MovieService(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "OurWatch",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Center(
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/logo2.png"),
                  fit: BoxFit.contain)),
        ),
      ),
    );
  }
}
