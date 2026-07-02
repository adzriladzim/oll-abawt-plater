import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'movie_event.dart';
import 'movie_state.dart';
import 'movie_model.dart';
import 'movie_service.dart';

export 'movie_event.dart';
export 'movie_state.dart';
export 'movie_model.dart';
export 'movie_service.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieService _movieService;
  List<Movie> _allMovies = [];
  final List<Movie> _favorites = [];

  MovieBloc(this._movieService) : super(MovieInitial()) {
    on<MovieLoadRequested>(_onLoadRequested);
    on<MovieSearchChanged>(_onSearchChanged);
    on<MovieToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadRequested(
      MovieLoadRequested event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      _allMovies = await _movieService.fetchMovies();
      emit(MovieLoaded(_allMovies, favorites: List.from(_favorites)));
    } catch (e) {
      emit(MovieError('Gagal memuat data film: $e'));
    }
  }

  Future<void> _onSearchChanged(
      MovieSearchChanged event, Emitter<MovieState> emit) async {
    if (state is! MovieLoaded) return;
    
    await _movieService.searchMovies(event.query);

    final q = event.query.toLowerCase();
    if (q.isEmpty) {
      emit(MovieLoaded(_allMovies, favorites: List.from(_favorites)));
    } else {
      final filtered = _allMovies
          .where((m) =>
              m.title.toLowerCase().contains(q) ||
              m.categoryMovie.toLowerCase().contains(q))
          .toList();
      emit(MovieLoaded(filtered, favorites: List.from(_favorites), searchQuery: event.query));
    }
  }

  void _onToggleFavorite(
      MovieToggleFavorite event, Emitter<MovieState> emit) {
    if (state is! MovieLoaded) return;
    final currentLoaded = state as MovieLoaded;

    final isFav = _favorites.any((m) => m.title == event.movie.title);
    if (isFav) {
      _favorites.removeWhere((m) => m.title == event.movie.title);
    } else {
      _favorites.add(event.movie);
    }

    emit(MovieLoaded(
      currentLoaded.movies,
      favorites: List.from(_favorites),
      searchQuery: currentLoaded.searchQuery,
    ));
  }
}
