// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';

import 'FavouriteMovieScreen.dart';
import 'SplashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: splashscreen(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String apikey = 'a3cda1a1451278cf277fbfa924fcf5fc';
  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhM2NkYTFhMTQ1MTI3OGNmMjc3ZmJmYTkyNGZjZjVmYyIsInN1YiI6IjY0ZGMyN2NlZDEwMGI2MDExYzg0MWEwNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.ZfNwvftxzJ6rdFflVj5WWb1Zy0Py4VNSlxB-QHXaRII';

  List topratedmovies = [];
  // For lazy load
  final ScrollController _scrollController = ScrollController();
  int _currentMax = 5;

  @override
  void initState() {
    super.initState();
    loadmovies();
    // For lazy loading
    topratedmovies = List.generate(_currentMax, (index) => "${index + 1}");
    _scrollController.addListener(() {
      // check More data is present of not
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  _getMoreData() {
    for (int i = _currentMax; i < _currentMax + 5; i++) {
      topratedmovies.add("${i + 1}");
    }
    _currentMax = _currentMax + 5;
  }

// For Fatching the data through the API
  loadmovies() async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apikey, readaccesstoken),
      logConfig: ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    // ignore: non_constant_identifier_names
    Map Result = await tmdbWithCustomLogs.v3.movies.getTopRated();
    setState(() {
      topratedmovies = Result['results'];
    });
  }

  // For Searchin movie
  void Filter(String Element) {
    List search = [];
    if (Element.isEmpty) {
      search = topratedmovies;
    } else {
      search = topratedmovies
          .where((value) =>
              value["title"].toLowerCase().contains(Element.toLowerCase()))
          .toList();
    }
    setState(() {
      topratedmovies = search;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("Movies App"),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            // For Searching Movies
            Text(
              "Top Rating Movies",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) => Filter(value),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: 'Search Movies',
                  suffixIcon: Icon(Icons.search)),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount: topratedmovies.length + 1,
                itemBuilder: (context, index) {
                  // For Lozy loading
                  if (index == topratedmovies.length) {
                    return const CupertinoActivityIndicator();
                  }
                  return ListTile(
                    // This is for Poster
                    leading: Image(
                      image: NetworkImage(
                        'https://image.tmdb.org/t/p/w500' +
                                topratedmovies[index]['poster_path'] ??
                            '',
                      ),
                    ),

                    // This is for Title

                    title: Text(
                      topratedmovies[index]['title'] ?? 'Loading',
                    ),
                    // This is for Rating
                    subtitle: Text(
                      topratedmovies[index]['vote_average'] != null
                          ? topratedmovies[index]['vote_average'].toString()
                          : 'Rating of movie',
                    ),

                    // Button for favourite list
                    trailing: IconButton(
                        onPressed: () {
                          Icons.favorite;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FavouriteMovie(
                                  // ignore: prefer_interpolation_to_compose_strings
                                  Poster: 'https://image.tmdb.org/t/p/w500' +
                                      (topratedmovies[index]['poster_path'] ??
                                          ''),
                                  Rating: topratedmovies[index]
                                              ['vote_average'] !=
                                          null
                                      ? topratedmovies[index]['vote_average']
                                          .toString()
                                      : 'Rating of movie',
                                  Title: topratedmovies[index]['title'] ??
                                      'No Title',
                                ),
                              ));
                        },
                        icon: const Icon(Icons.favorite_border_rounded)),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 35,
                  );
                },
              ),
            ),
          ],
        ));
  }
}
