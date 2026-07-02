import 'movie_model.dart';

abstract class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movies;
  final List<Movie> favorites;
  final String searchQuery;

  MovieLoaded(this.movies, {this.favorites = const [], this.searchQuery = ''});
}

class MovieError extends MovieState {
  final String message;
  MovieError(this.message);
}
