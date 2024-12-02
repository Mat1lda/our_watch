import 'package:flutter/cupertino.dart';
import 'package:out_watch/model/movie.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class MovieTitle extends StatelessWidget {
  final GetIt getIt = GetIt.instance;
  final double height;
  final double width;
  final Movie movies;

  MovieTitle(this.height, this.width, this.movies);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [moviePosterWidget(movies.posterURL()), movieInfoWidget()],
      ),
    );
  }

  Widget moviePosterWidget(String imgURL) {
    return Container(
      height: height,
      width: width * 0.35,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imgURL),
        ),
      ),
    );
  }

  Widget movieInfoWidget() {
    return Container(
      height: height,
      width: width * 0.66,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: width * 0.56,
                child: Text(
                  movies.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Text(
                movies.ratings.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, height * 0.02, 0, 0),
            child: Text(
              '${movies.language.toUpperCase()} | R: ${movies.isAdult} | ${movies.releaseDate}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, height * 0.07, 0, 0),
            child: Text(
              '${movies.description}',
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          )
        ],
      ),
    );
  }
}
