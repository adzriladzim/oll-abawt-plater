import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/movie_bloc.dart';
import 'movie_detail.dart';
import 'favorite_page.dart';

class MovieList extends StatefulWidget {
  const MovieList({super.key});

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  final TextEditingController _searchController = TextEditingController();
  final MovieService _movieService = MovieService();
  Timer? _debounce;

  // Future untuk film unggulan
  late final Future<Movie> _featuredMovieFuture;

  @override
  void initState() {
    super.initState();
    _featuredMovieFuture = _movieService.fetchFeaturedMovie();
    context.read<MovieBloc>().add(MovieLoadRequested());
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _movieService.searchMovies(query);
      context.read<MovieBloc>().add(MovieSearchChanged(query));
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _movieService.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text(
          'Movie Catalog',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            tooltip: 'Favorit',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritePage(),
                ),
              );
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari film...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Color(0xFF94A3B8)),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SECTION 1: Film Unggulan (FutureBuilder)
                  _buildSectionHeader(
                    icon: Icons.star_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    title: 'Film Unggulan',
                    subtitle: 'FutureBuilder — data dimuat satu kali',
                  ),
                  const SizedBox(height: 10),
                  _buildFutureSection(),

                  const SizedBox(height: 24),

                  // SECTION 2: Pencarian Real-time (StreamBuilder)
                  _buildSectionHeader(
                    icon: Icons.stream,
                    iconColor: const Color(0xFF6366F1),
                    title: 'Pencarian Real-time',
                    subtitle: 'StreamBuilder — update tiap ketukan keyboard',
                  ),
                  const SizedBox(height: 10),
                  _buildStreamSection(),

                  const SizedBox(height: 24),

                  // SECTION 3: Semua Film (BLoC)
                  _buildSectionHeader(
                    icon: Icons.view_list_rounded,
                    iconColor: const Color(0xFF0EA5E9),
                    title: 'Semua Film',
                    subtitle: 'BLoC — state dikelola MovieBloc',
                  ),
                  const SizedBox(height: 10),
                  _buildBlocSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFutureSection() {
    return FutureBuilder<Movie>(
      future: _featuredMovieFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingCard('Memuat film unggulan...');
        }
        if (snapshot.hasError) {
          return _buildErrorCard('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) return const SizedBox.shrink();

        final movie = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, size: 14, color: Color(0xFFD97706)),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'FutureBuilder selesai! Film dengan rating tertinggi ditampilkan.',
                      style: TextStyle(fontSize: 11, color: Color(0xFFD97706)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetail(movie: movie),
                  ),
                );
              },
              child: _MovieCardWidget(movie: movie),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStreamSection() {
    return StreamBuilder<List<Movie>>(
      stream: _movieService.searchStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: const [
                Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
                SizedBox(width: 10),
                Text(
                  'Ketik sesuatu di kotak pencarian...',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                ),
              ],
            ),
          );
        }

        final movies = snapshot.data!;
        if (movies.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'Film tidak ditemukan',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFC7D2FE)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 14, color: Color(0xFF6366F1)),
                  const SizedBox(width: 6),
                  Text(
                    'StreamBuilder menemukan ${movies.length} film.',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF6366F1)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ...movies.map(
              (m) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetail(movie: m),
                    ),
                  );
                },
                child: _MovieCardWidget(movie: m),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBlocSection() {
    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        if (state is MovieInitial || state is MovieLoading) {
          return _buildLoadingCard('BLoC sedang memuat data...');
        }
        if (state is MovieError) {
          return _buildErrorCard(state.message);
        }
        if (state is MovieLoaded) {
          if (state.movies.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Tidak ada film yang sesuai',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                ),
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFBAE6FD)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 14, color: Color(0xFF0284C7)),
                    const SizedBox(width: 6),
                    Text(
                      'BLoC state: MovieLoaded — ${state.movies.length} film tersedia.',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF0284C7)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ...state.movies.map(
                (m) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetail(movie: m),
                      ),
                    );
                  },
                  child: _MovieCardWidget(movie: m),
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingCard(String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Text(
            message,
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFEF4444)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFFEF4444), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _MovieCardWidget extends StatelessWidget {
  final Movie movie;
  const _MovieCardWidget({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              movie.imageUrl,
              width: 75,
              height: 105,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 75,
                height: 105,
                color: const Color(0xFFE2E8F0),
                child: const Icon(
                  Icons.movie_creation_outlined,
                  size: 32,
                  color: Color(0xFF94A3B8),
                ),
              ),
              loadingBuilder: (_, child, progress) => progress == null
                  ? child
                  : Container(
                      width: 75,
                      height: 105,
                      color: const Color(0xFFE2E8F0),
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Text(
                  movie.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  movie.categoryMovie,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                if (movie.synopsis.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    movie.synopsis,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const SizedBox(width: 26, height: 22),
                          Positioned(
                            top: 0,
                            child: ClipPath(
                              clipper: TriangleClipper(),
                              child: Container(
                                width: 26,
                                height: 22,
                                color: const Color(0xFFFFEB3B),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 1,
                            child: Text(
                              movie.ageRating,
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        movie.formatType,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 3),
                        Text(
                          movie.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
