import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it/get_it.dart';
import 'package:out_watch/service/http_service.dart';
import 'package:out_watch/model/movie.dart';
import 'package:dio/dio.dart';
class MovieService{
  final GetIt getIt = GetIt.instance;

  late HTTPService http;
  MovieService(){
    http = getIt.get<HTTPService>();
  }

  Future<List<Movie>> getPopularMovies({required int page}) async{
    Response? response = await http.get('/movie/popular', query: {
      'page': page
    });
    if(response?.statusCode == 200){
      Map data = response?.data;
      List<Movie> movies = data['results'].map<Movie>((movieData){
        return Movie.fromJson(movieData);
    }).toList();
    return movies;
    }else{
      throw Exception('cant load');
    }
  }
}