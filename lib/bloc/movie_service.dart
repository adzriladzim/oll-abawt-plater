import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'movie_model.dart';

const List<Movie> _localMovies = [
  Movie(
    title: 'Sekawan Limo 2: Gunung Klawih',
    categoryMovie: 'Comedy, Horror',
    imageUrl: 'https://nos.jkt-1.neo.id/media.cinema21.co.id/movie-images/16SK2G.jpg',
    ageRating: 'R13',
    formatType: '2D',
    synopsis: 'Lima sekawan kembali berpetualang di Gunung Klawih yang penuh misteri dan teror.',
    rating: 7.8,
  ),
  Movie(
    title: 'Suamiku Lukaku',
    categoryMovie: 'Drama',
    imageUrl: 'https://nos.jkt-1.neo.id/media.cinema21.co.id/movie-images/16SLUU.jpg',
    ageRating: 'D17',
    formatType: '2D',
    synopsis: 'Kisah cinta rumah tangga yang penuh lika-liku dan pengorbanan.',
    rating: 7.2,
  ),
  Movie(
    title: 'Monster Pabrik Rambut',
    categoryMovie: 'Fantasy, Horror',
    imageUrl: 'https://nos.jkt-1.neo.id/media.cinema21.co.id/movie-images/16MPRT.jpg',
    ageRating: 'D17',
    formatType: '2D',
    synopsis: 'Teror makhluk misterius yang menghantui sebuah pabrik rambut di kota kecil.',
    rating: 6.9,
  ),
  Movie(
    title: 'Badut Gendong',
    categoryMovie: 'Action, Horror',
    imageUrl: 'https://nos.jkt-1.neo.id/media.cinema21.co.id/movie-images/16BGEG.jpg',
    ageRating: 'D17',
    formatType: '2D',
    synopsis: 'Aksi menegangkan melawan badut pembunuh yang mengincar anak-anak.',
    rating: 7.5,
  ),
  Movie(
    title: 'Jumbo',
    categoryMovie: 'Animation, Family',
    imageUrl: 'https://nos.jkt-1.neo.id/media.cinema21.co.id/movie-images/16JMBO.jpg',
    ageRating: 'SU',
    formatType: '2D',
    synopsis: 'Petualangan gajah kecil yang mencari jati dirinya di dunia yang luas.',
    rating: 8.1,
  ),
  Movie(
    title: 'Qodrat 2',
    categoryMovie: 'Horror, Thriller',
    imageUrl: 'https://nos.jkt-1.neo.id/media.cinema21.co.id/movie-images/16QD2T.jpg',
    ageRating: 'D17',
    formatType: '2D',
    synopsis: 'Ustadz Qodrat kembali menghadapi ancaman iblis yang lebih kuat dari sebelumnya.',
    rating: 7.4,
  ),
];

class MovieService {
  static const String _apiKey = ''; 

  final StreamController<List<Movie>> _searchController =
      StreamController<List<Movie>>.broadcast();

  Stream<List<Movie>> get searchStream => _searchController.stream;

  List<Movie> _cachedMovies = [];

  String _mapGenres(List<dynamic>? genreIds) {
    if (genreIds == null || genreIds.isEmpty) return 'General';
    final genreMap = {
      28: 'Action',
      12: 'Adventure',
      16: 'Animation',
      35: 'Comedy',
      80: 'Crime',
      99: 'Documentary',
      18: 'Drama',
      10751: 'Family',
      14: 'Fantasy',
      36: 'History',
      27: 'Horror',
      10402: 'Music',
      9648: 'Mystery',
      10749: 'Romance',
      878: 'Sci-Fi',
      10770: 'TV Movie',
      53: 'Thriller',
      10752: 'War',
      37: 'Western',
    };
    final genres = genreIds.map((id) => genreMap[id] ?? 'Other').take(3).toList();
    return genres.join(', ');
  }

  Movie _mapTmdbToMovie(Map<String, dynamic> json) {
    final posterPath = json['poster_path'] as String?;
    final imageUrl = posterPath != null
        ? 'https://image.tmdb.org/t/p/w500$posterPath'
        : 'https://images.unsplash.com/photo-1594909122845-11baa439b7bf?q=80&w=500';
    return Movie(
      title: json['title'] as String? ?? 'Untitled',
      categoryMovie: _mapGenres(json['genre_ids'] as List<dynamic>?),
      imageUrl: imageUrl,
      ageRating: (json['adult'] as bool? ?? false) ? 'D17' : 'SU',
      formatType: '2D',
      synopsis: json['overview'] as String? ?? '',
      rating: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Future<List<Movie>> fetchMovies() async {
    if (_apiKey.isEmpty) {
      await Future.delayed(const Duration(seconds: 1));
      _cachedMovies = List.from(_localMovies);
      return _localMovies;
    }

    try {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/popular?api_key=$_apiKey&language=id-ID&page=1'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.body);
        final List<dynamic> results = decoded['results'] ?? [];
        final movies = results.map((item) => _mapTmdbToMovie(item)).toList();
        _cachedMovies = movies;
        return movies;
      } else {
        throw Exception('Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Gagal mengambil data TMDB API (Menggunakan fallback lokal): $e');
      _cachedMovies = List.from(_localMovies);
      return _localMovies;
    }
  }

  Future<Movie> fetchFeaturedMovie() async {
    if (_cachedMovies.isEmpty) {
      await fetchMovies();
    }
    if (_cachedMovies.isEmpty) {
      return _localMovies.first;
    }
    return _cachedMovies.reduce((a, b) => a.rating > b.rating ? a : b);
  }

  Future<void> searchMovies(String query) async {
    if (query.trim().isEmpty) {
      _searchController.add(_cachedMovies);
      return;
    }

    if (_apiKey.isEmpty) {
      final q = query.toLowerCase();
      final filtered = _cachedMovies
          .where((m) =>
              m.title.toLowerCase().contains(q) ||
              m.categoryMovie.toLowerCase().contains(q))
          .toList();
      _searchController.add(filtered);
      return;
    }

    try {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/search/movie?api_key=$_apiKey&query=${Uri.encodeComponent(query)}&language=id-ID'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.body);
        final List<dynamic> results = decoded['results'] ?? [];
        final movies = results.map((item) => _mapTmdbToMovie(item)).toList();
        _searchController.add(movies);
      } else {
        throw Exception('Status code: ${response.statusCode}');
      }
    } catch (e) {
      final q = query.toLowerCase();
      final filtered = _cachedMovies
          .where((m) =>
              m.title.toLowerCase().contains(q) ||
              m.categoryMovie.toLowerCase().contains(q))
          .toList();
      _searchController.add(filtered);
    }
  }

  void dispose() => _searchController.close();
}
