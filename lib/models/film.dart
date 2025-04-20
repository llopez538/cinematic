import 'dart:convert';

class Film {
  static const String urlImage = 'https://image.tmdb.org/t/p';
  final String title;
  final String originalTitle;
  final String overview;
  final String originalLanguage;
  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final String? posterPath;
  final String? releaseDate;
  final double voteAverage;
  final int voteCount;

  Film({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.originalLanguage,
    required this.genreIds,
    this.backdropPath,
    this.posterPath,
    this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
  });

  // Método para convertir a Map (para SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'genre_ids': jsonEncode(genreIds), // Lista a JSON String
    };
  }

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      backdropPath: json['backdrop_path'],
      originalLanguage: json['original_language'] ?? '',
      posterPath: json['poster_path'],
      releaseDate: json['release_date'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
    );
  }

  String get fullPosterPath {
    if (posterPath == null) return '';
    return '$urlImage/w500$posterPath';
  }

  String get fullBackdropPath {
    if (backdropPath == null) return '';
    return '$urlImage/w1280$backdropPath';
  }
}
