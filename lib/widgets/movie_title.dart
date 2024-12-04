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
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          moviePosterWidget(movies.posterURL()),
          movieInfoWidget(),
        ],
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
          fit: BoxFit.cover, // Ensure the image scales properly
        ),
      ),
    );
  }

  Widget movieInfoWidget() {
    return Expanded(  // Use Expanded to allow dynamic width adjustment
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: width * 0.56,  // Constrain the width of the title
                  child: Text(
                    movies.name,
                    overflow: TextOverflow.ellipsis,  // Prevent text overflow
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Text(
                  movies.ratings.toString().substring(0,3),
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
                maxLines: 6,  // Limit to 6 lines
                overflow: TextOverflow.ellipsis,  // Prevent text overflow
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

