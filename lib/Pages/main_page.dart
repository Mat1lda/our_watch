import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:out_watch/model/search_category.dart';
import 'package:out_watch/model/movie.dart';
import 'package:out_watch/widgets/movie_title.dart';
import 'package:out_watch/controller/main_page_controller.dart';
import 'package:out_watch/model/main_page_data.dart';

final mainPageDataControllerProvider =
    StateNotifierProvider<MainPageController, MainPageData>(
  (ref) {
    return MainPageController();
  },
);
final selectedMoviePosterURLProvider = StateProvider<String>((ref) {
  final movies = ref.watch(mainPageDataControllerProvider).movies;
  if (movies.isEmpty) {
    return 'https://www.uplevo.com/img/designbox/poster-phim-me-and-earl.jpg'; // Default fallback image
  } else {
    return movies[0].posterURL(); // Get the first movie's poster URL
  }
},);
class MainPage extends ConsumerWidget {
  late double _heightScreen;
  late double _widthScreen;
  late String selectedMoviesPosterURL;
  late var searchTextFieldController = TextEditingController();

  MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _heightScreen = MediaQuery.of(context).size.height;
    _widthScreen = MediaQuery.of(context).size.width;

    // Access the mainPageData from the provider directly
    final mainPageData = ref.watch(mainPageDataControllerProvider);
    final mainPageController =
        ref.watch(mainPageDataControllerProvider.notifier);
    selectedMoviesPosterURL = ref.watch(selectedMoviePosterURLProvider);
    // Initialize searchTextFieldController
    searchTextFieldController = TextEditingController();
    searchTextFieldController.text = mainPageData.searchText;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Container(
        height: _heightScreen,
        width: _widthScreen,
        child: Stack(
          alignment: Alignment.center,
          children: [
            backgroundWidget(),
            foregroundWidget(mainPageData, mainPageController, ref)
          ],
        ),
      ),
    );
  }

  Widget backgroundWidget() {
    final imageUrl = selectedMoviesPosterURL.isEmpty
        ? 'https://www.uplevo.com/img/designbox/poster-phim-me-and-earl.jpg' // Use a valid default image URL
        : selectedMoviesPosterURL;
    return Container(
      height: _heightScreen,
      width: _widthScreen,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 15.0,
          sigmaY: 15.0,
        ),
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
        ),
      ),
    );
  }

  Widget foregroundWidget(
      MainPageData mainPageData, MainPageController mainPageController, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, _heightScreen * 0.02, 0, 0),
      width: _widthScreen * 0.88,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          topbarWidget(mainPageData, mainPageController),
          Container(
            height: _heightScreen * 0.83,
            padding: EdgeInsets.symmetric(vertical: _heightScreen * 0.01),
            child: movieListViewWidget(mainPageData, mainPageController, ref),
          )
        ],
      ),
    );
  }

  Widget topbarWidget(
      MainPageData mainPageData, MainPageController mainPageController) {
    return SafeArea(
      child: Container(
        height: _heightScreen * 0.08,
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            searchViewWidget(mainPageController),
            categorySelectionWidget(mainPageData, mainPageController)
          ],
        ),
      ),
    );
  }

  Widget searchViewWidget(MainPageController mainPageController) {
    final border = InputBorder.none;
    return Flexible(
      // Wrap with Flexible
      child: Container(
        width: _widthScreen * 0.5,
        height: _heightScreen * 0.05,
        child: TextField(
          controller: searchTextFieldController,
          onSubmitted: (value) => mainPageController.updateTextSearch(value),
          style: TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
            focusedBorder: border,
            border: border,
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white24,
            ),
            hintStyle: TextStyle(color: Colors.white54),
            filled: false,
            fillColor: Colors.white,
            hintText: "Hôm nay xem....",
          ),
        ),
      ),
    );
  }

  Widget categorySelectionWidget(
      MainPageData mainPageData, MainPageController mainPageController) {
    return DropdownButton(
      dropdownColor: Colors.black38,
      value: mainPageData.searchCategory,
      icon: Icon(
        color: Colors.white24,
        Icons.menu,
      ),
      underline: Container(
        height: 1,
        color: Colors.white24,
      ),
      onChanged: (value) => value.toString().isNotEmpty
          ? mainPageController.updateSearchCategory(value!)
          : null,
      items: [
        DropdownMenuItem(
          child: Text(SearchCategory.popular,
              style: TextStyle(color: Colors.white)),
          value: SearchCategory.popular,
        ),
        DropdownMenuItem(
          child: Text(
            SearchCategory.upcoming,
            style: TextStyle(color: Colors.white),
          ),
          value: SearchCategory.upcoming,
        ),
        DropdownMenuItem(
          child: Text(
            SearchCategory.none,
            style: TextStyle(color: Colors.white),
          ),
          value: SearchCategory.none,
        ),
      ],
    );
  }

  Widget movieListViewWidget(MainPageData mainPageData, MainPageController mainPageController, WidgetRef ref) {
    final List<Movie> movies = mainPageData.movies;

    if (movies.isNotEmpty) {
      return NotificationListener<ScrollNotification>(
        onNotification: (onScrollNotification) {
          if (onScrollNotification is ScrollEndNotification) {
            final before = onScrollNotification.metrics.extentBefore;
            final max = onScrollNotification.metrics.maxScrollExtent;

            // Check if the user reached the bottom of the list
            if (before == max) {
              // Trigger to load more movies
              mainPageController.getMovies();
              return true;
            }
          }
          return false;
        },
        child: ListView.builder(
          itemCount: movies.length,
          itemBuilder: (BuildContext context, int count) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: _heightScreen * 0.01),
              child: GestureDetector(
                onTap: () {
                  ref.read(selectedMoviePosterURLProvider.notifier).state = movies[count].posterURL();
                },
                child: MovieTitle(
                  _heightScreen * 0.2, // height of the movie title widget
                  _widthScreen * 0.75, // Adjust the width to fit inside the screen
                  movies[count],
                ),
              ),
            );
          },
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      );
    }
  }

}
