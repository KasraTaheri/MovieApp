import 'package:movie_app/models/movie.dart';

class MovieList {
  int page;
  int totalResults;
  int totalPages;
  List<Movie> movies;

  MovieList({this.page, this.totalResults, this.totalPages, this.movies});

  factory MovieList.fromJson(Map<String, dynamic> json) {
    var list = json['results'] as List;
    var movies = list.map((i) => Movie.fromJson(i)).toList();

    return MovieList(
      page: json['page'],
      totalResults: json['total_results'],
      totalPages: json['total_pages'],
      movies: movies
    );
  }
}
