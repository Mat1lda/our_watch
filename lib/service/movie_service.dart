import 'package:get_it/get_it.dart';
import 'package:get_it/get_it.dart';
import 'package:out_watch/service/http_service.dart';

class MovieService{
  final GetIt getIt = GetIt.instance;

  late HTTPService httpService;
  MovieService(){
    httpService = getIt.get<HTTPService>();
  }
}