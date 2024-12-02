import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:out_watch/model/search_category.dart';
import 'package:out_watch/model/movie.dart';
import 'package:out_watch/widgets/movie_title.dart';

class MainPage extends ConsumerWidget {
  late double _heightScreen;
  late double _widthScreen;
  late var searchTextFieldController = TextEditingController();

  MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _heightScreen = MediaQuery.of(context).size.height;
    _widthScreen = MediaQuery.of(context).size.width;
    searchTextFieldController = TextEditingController();
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Container(
        height: _heightScreen,
        width: _widthScreen,
        child: Stack(
          alignment: Alignment.center,
          children: [backgroundWidget(), foregroundWidget()],
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

  Widget foregroundWidget() {
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
            child: movieListViewWidget(),
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
    return Container(
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
            hintText: "Hôm nay xem...."),
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
      underline:
      Container(
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

  Widget movieListViewWidget() {
    final List<Movie> movies = [];

    for (var i = 0; i < 20; i++) {
      movies.add(Movie(
          'Moana 2',
          'EN',
          false,
          'After receiving an unexpected call from her wayfinding ancestors, Moana journeys alongside Maui and a new crew to the far seas of Oceania and into dangerous, long-lost waters for an adventure unlike anything she has ever faced.',
          "/yh64qw9mgXBvlaWDi7Q9tpUBAvH.jpg",
          "/3V4kLQg0kSqPLctI5ziYWabAZYF.jpg",
          7.2,
          '2024-11-27'));
    }
    if (movies.length > 0) {
      return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (BuildContext context, int count) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  vertical: _heightScreen * 0.01, horizontal: 0),
              child: GestureDetector(
                onTap: () {},
                child: MovieTitle(_heightScreen * 0.2, _widthScreen * 0.8, movies[count]),
              ),
            );
          });
    } else {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      );
    }
  }
}
