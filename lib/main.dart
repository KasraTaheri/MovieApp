import 'package:flutter/material.dart';
import 'package:movie_app/services/authentication.dart';
import 'package:movie_app/ui/root_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Movie Database",
        theme: new ThemeData(
            primarySwatch: Colors.yellow, brightness: Brightness.dark
            ),
        home: new RootPage(
          auth: new Auth(),
        ));
  }
}
