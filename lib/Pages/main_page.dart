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

class MainPage extends ConsumerWidget {
  late double _heightScreen;
  late double _widthScreen;
  late var searchTextFieldController = TextEditingController();

  MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _heightScreen = MediaQuery.of(context).size.height;
    _widthScreen = MediaQuery.of(context).size.width;

    // Access the mainPageData from the provider directly
    final mainPageData = ref.watch(mainPageDataControllerProvider);

    // Initialize searchTextFieldController
    searchTextFieldController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Container(
        height: _heightScreen,
        width: _widthScreen,
        child: Stack(
          alignment: Alignment.center,
          children: [backgroundWidget(), foregroundWidget(mainPageData)],
        ),
      ),
    );
  }

  Widget backgroundWidget() {
    return Container(
      height: _heightScreen,
      width: _widthScreen,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: AssetImage("assets/images/bg.jpg"),
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

  Widget foregroundWidget(MainPageData mainPageData) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, _heightScreen * 0.02, 0, 0),
      width: _widthScreen * 0.88,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          topbarWidget(),
          Container(
            height: _heightScreen * 0.83,
            padding: EdgeInsets.symmetric(vertical: _heightScreen * 0.01),
            child: movieListViewWidget(mainPageData),
          )
        ],
      ),
    );
  }


  Widget topbarWidget() {
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
          children: [searchViewWidget(), categorySelectionWidget()],
        ),
      ),
    );
  }

  Widget searchViewWidget() {
    final border = InputBorder.none;
    return Flexible(  // Wrap with Flexible
      child: Container(
        width: _widthScreen * 0.5,
        height: _heightScreen * 0.05,
        child: TextField(
          controller: searchTextFieldController,
          onSubmitted: (value) {},
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


  Widget categorySelectionWidget() {
    return DropdownButton(
      dropdownColor: Colors.black87,
      value: SearchCategory.popular,
      icon: Icon(
        color: Colors.white24,
        Icons.menu,
      ),
      underline: Container(
        height: 1,
        color: Colors.white24,
      ),
      onChanged: (value) {},
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

  Widget movieListViewWidget(MainPageData mainPageData) {
    final List<Movie> movies = mainPageData.movies;

    if (movies.isNotEmpty) {
      return ListView.builder(
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int count) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: _heightScreen * 0.01),
            child: GestureDetector(
              onTap: () {},
              child: MovieTitle(
                _heightScreen * 0.2, // height of the movie title widget
                _widthScreen * 0.75, // Adjust the width to fit inside the screen
                movies[count],
              ),
            ),
          );
        },
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
