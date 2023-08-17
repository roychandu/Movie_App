// ignore_for_file: file_names

import 'package:flutter/material.dart';

class FavouriteMovie extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final String Poster, Rating, Title;

  FavouriteMovie(
      {required this.Poster, required this.Rating, required this.Title});

  @override
  State<FavouriteMovie> createState() => _FovoriateScreenState();
}

class _FovoriateScreenState extends State<FavouriteMovie> {
  final List Store = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Center(
          child: Text(
            'favourite Movies',
            style: TextStyle(fontSize: 30),
          ),
        )),
        body: ListTile(
          leading: Image.network(widget.Poster),
          title: Text(widget.Title),
          subtitle: Text(widget.Rating),
          trailing: const Icon(
            Icons.favorite_rounded,
            color: Colors.red,
          ),
        ));
  }
}
