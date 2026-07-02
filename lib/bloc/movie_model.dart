class Movie {
  final String title;
  final String categoryMovie;
  final String imageUrl;
  final String ageRating;
  final String formatType;
  final String synopsis;
  final double rating;

  const Movie({
    required this.title,
    required this.categoryMovie,
    required this.imageUrl,
    required this.ageRating,
    required this.formatType,
    this.synopsis = '',
    this.rating = 0.0,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        title: json['title'] as String,
        categoryMovie: json['categoryMovie'] as String,
        imageUrl: json['imageUrl'] as String,
        ageRating: json['ageRating'] as String,
        formatType: json['formatType'] as String,
        synopsis: json['synopsis'] as String? ?? '',
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      );
}
