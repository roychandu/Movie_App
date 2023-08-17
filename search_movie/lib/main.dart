// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';

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

  @override
  void initState() {
    super.initState();
    loadmovies();
  }

  loadmovies() async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apikey, readaccesstoken),
      logConfig: ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    Map Result = await tmdbWithCustomLogs.v3.movies.getTopRated();
    setState(() {
      topratedmovies = Result['results'];
      print((Result));
    });
  }

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
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.list_alt_rounded))
          ],
          title: Center(
            child: Text("Movies App"),
          ),
        ),
        body: Column(
          children: [
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
                itemCount: topratedmovies.length,
                itemBuilder: (context, index) {
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

                    title: Text(
                      topratedmovies[index]['title'] ?? 'Loading',
                    ),

                    subtitle: Text(
                      topratedmovies[index]['vote_average'] != null
                          ? topratedmovies[index]['vote_average'].toString()
                          : 'Rating of movie',
                    ),

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
              ),
            ),
          ],
        ));
  }
}
