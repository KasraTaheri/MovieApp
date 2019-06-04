import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:movie_app/models/movieList.dart';

final apiKey = "efc825ecbe32ad5877502691296ebafc";

abstract class BaseMovies {
  Future<MovieList> upcomingMovies();

  Future<MovieList> popularMovies();
}

class Movies implements BaseMovies {
  Future<MovieList> upcomingMovies() async {
    var response = await get(
        "https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey&language=sv-SE&page=1");

    if (response.statusCode == 200) {
      return MovieList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<MovieList> popularMovies() async {
    var response =  await get(
        "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=sv-SE&page=1");
    
    if (response.statusCode == 200) {
      return MovieList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }
}
