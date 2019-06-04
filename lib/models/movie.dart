class Movie {
  int id;
  double voteAverage;
  String title;
  String overview;
  String image;
  String releaseDate;

  Movie(
      {this.id,
      this.voteAverage,
      this.title,
      this.overview,
      this.image,
      this.releaseDate});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        id: json['id'],
        voteAverage: json['vote_average'].toDouble(),
        title: json['title'],
        overview: json['overview'],
        image: 'https://image.tmdb.org/t/p/w500' + json['poster_path'],
        releaseDate: json['release_date']);
  }
}
