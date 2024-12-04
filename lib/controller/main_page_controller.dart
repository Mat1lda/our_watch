import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:out_watch/model/main_page_data.dart';
import 'package:out_watch/model/search_category.dart';
import 'package:out_watch/service/movie_service.dart';
import 'package:get_it/get_it.dart';
import 'package:out_watch/service/movie_service.dart';
import 'package:out_watch/model/movie.dart';

class MainPageController extends StateNotifier<MainPageData> {
  MainPageController([MainPageData? state])
      : super(state ?? MainPageData.initial()) {
    getMovies();
  }

  final MovieService movieService = GetIt.instance.get<MovieService>();

  Future<void> getMovies() async {
    try {
      List<Movie> movies = [];
      if (state.searchText.isEmpty) {
        if (state.searchCategory == SearchCategory.popular) {
          movies = await movieService.getPopularMovies(page: state.page);
        } else if (state.searchCategory == SearchCategory.upcoming) {
          movies = await movieService.getUpComingMovies(page: state.page);
        } else if (state.searchCategory == SearchCategory.none) {
          movies = [];
        }else{
          movies = await movieService.searchMovies(state.searchText, page: state.page);
        }
      }
      if (movies.isNotEmpty) {
        state = state.copyWith(
          movies: [...state.movies, ...movies],
          page: state.page + 1, // Increment page only if new data was fetched
        );
      }
    } catch (e) {
      print("Error fetching movies: $e");
    }
  }

  void updateSearchCategory(String category) {
    try {
      state = state.copyWith(
          movies: [], page: 1, searchCategory: category, searchText: '');
      getMovies();
    } catch (e) {
      print(e);
    }
  }

  void updateTextSearch(String textSearch) {
    try {
      state = state.copyWith(
          movies: [],
          page: 1,
          searchCategory: SearchCategory.none,
          searchText: textSearch);
      getMovies();
    } catch (e) {
      print(e);
    }
  }
}
