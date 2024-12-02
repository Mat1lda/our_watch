import 'package:get_it/get_it.dart';
import 'package:out_watch/model/config.dart';

class Movie {
  final String name;
  final String language;
  final bool isAdult;
  final String description;
  final String posterPath;
  final String backdropPath;
  final num ratings;
  final String releaseDate;

  Movie(this.name, this.language, this.isAdult, this.description,
      this.posterPath, this.backdropPath, this.ratings, this.releaseDate);

  factory Movie.fromJson(Map<String, dynamic> json){
    return Movie(json['title'], json['original_language'], json['adult'], json['overview'], json['poster_path'], json['backdrop_path'], json['vote_average'], json['release_date']);
  }
  String posterURL(){
    final AppConfig appConfig = GetIt.instance.get<AppConfig>();
    return '${appConfig.BASE_IMAGE_API_URL}${this.posterPath}';
  }

}