import 'dart:async';

import 'package:flutter/material.dart';
import 'package:search_movie/main.dart';

class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: const Center(
            child: Text(
          "Splash Screen",
          style: TextStyle(
              fontSize: 40,
              color: Color.fromARGB(255, 1, 137, 248),
              fontWeight: FontWeight.w900),
        )),
      ),
    );
  }
}
