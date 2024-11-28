import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:out_watch/model/config.dart';
class HTTPService{
  final Dio dio = Dio();
  final GetIt getIt = GetIt.instance;

  String? base_url;
  String? api_key;

  HTTPService(){
    AppConfig config = getIt.get<AppConfig>();
    base_url = config.BASE_API_URL;
    api_key = config.API_KEY;
  }

  Future<Response?> get(String path, {Map<String, dynamic>? query}) async {
    try {
      String _url = '$base_url$path';
      Map<String, dynamic> _query = {
        'api_key': api_key,
        'language': 'en-US',
      };
      if (query != null) {
        _query.addAll(query);
      }
      return await dio.get(_url, queryParameters: _query);
    } on DioError catch (e) {
      print('Unable to perform get request.');
      print('DioError:$e');
    }
  }
}