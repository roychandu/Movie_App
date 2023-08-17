// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';

import 'SplashScreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
  final ScrollController _scrollController = ScrollController();
  int _currentMax = 5;

  @override
  void initState() {
    super.initState();
    loadmovies();
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
    setState(() {});
  }

  loadmovies() async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apikey, readaccesstoken),
      logConfig: const ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    // ignore: non_constant_identifier_names
    Map<dynamic, dynamic> Result =
        await tmdbWithCustomLogs.v3.movies.getTopRated();
    setState(() {
      topratedmovies = Result['results'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text("Movies App"),
          ),
        ),
        body: ListView.separated(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          itemCount: topratedmovies.length + 1,
          itemBuilder: (context, index) {
            if (index == topratedmovies.length) {
              return const CupertinoActivityIndicator();
            }
            return ListTile(
              // This Container for Poster
              leading: Image(
                image: NetworkImage(
                  'https://image.tmdb.org/t/p/w500' +
                          topratedmovies[index]['poster_path'] ??
                      '',
                ),
              ),

              // This container or Title and Rating

              title: SizedBox(
                height: 30,
                child: Text(
                  topratedmovies[index]['title'] ?? 'Loading',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              subtitle: Text(
                  topratedmovies[index]['vote_average'] != null
                      ? topratedmovies[index]['vote_average'].toString()
                      : 'Rating of movie',
                  style: const TextStyle(fontSize: 15)),

              // Button for favorite list
              trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border_rounded)),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              height: 40,
            );
          },
        ));
  }
}
