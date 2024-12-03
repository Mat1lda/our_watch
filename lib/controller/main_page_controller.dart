import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:out_watch/model/main_page_data.dart';
import 'package:out_watch/service/movie_service.dart';
import 'package:get_it/get_it.dart';
import 'package:out_watch/service/movie_service.dart';
import 'package:out_watch/model/movie.dart';

class MainPageController extends StateNotifier<MainPageData> {
  MainPageController([MainPageData ?state])
      : super(state??MainPageData.initial()) {
    getMovies();
  }

  final MovieService movieService = GetIt.instance.get<MovieService>();

  Future<void> getMovies() async{
    try{
      List<Movie> movies = [];
      movies = await movieService.getPopularMovies(page: state.page);
      state = state.copyWith(movies: [...state.movies, ... movies],page: state.page + 1);
    } catch(e){
      print("Error fetching movies: $e");
    }
  }

}
