import 'movie_model.dart';

abstract class MovieEvent {}

class MovieLoadRequested extends MovieEvent {}

class MovieSearchChanged extends MovieEvent {
  final String query;
  MovieSearchChanged(this.query);
}

class MovieToggleFavorite extends MovieEvent {
  final Movie movie;
  MovieToggleFavorite(this.movie);
}
