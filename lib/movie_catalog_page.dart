import 'package:flutter/material.dart';

class Movie {
  final String title;
  final String categoryMovie;
  final String imageUrl;
  final String ageRating;
  final String formatType;

  const Movie({
    required this.title,
    required this.categoryMovie,
    required this.imageUrl,
    required this.ageRating,
    required this.formatType,
  });
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

class MovieCatalogPage extends StatelessWidget {
  const MovieCatalogPage({super.key});

  final List<Movie> movies = const [
    Movie(
      title: 'Sekawan Limo 2: Gunung Klawih',
      categoryMovie: 'Comedy, Horror',
      imageUrl: 'https://nos.jkt-1.neo.id/media.cinema21.co.id/movie-images/16SK2G.jpg', // Placeholder TMDB URL
      ageRating: 'R13',
      formatType: '2D',
    ),
    Movie(
      title: 'Suamiku Lukaku',
      categoryMovie: 'Drama',
      imageUrl: 'https://nos.jkt-1.neo.id/media.cinema21.co.id/movie-images/16SLUU.jpg',
      ageRating: 'D17',
      formatType: '2D',
    ),
    Movie(
      title: 'Monster Pabrik Rambut',
      categoryMovie: 'Fantasy, Horror',
      imageUrl: 'https://nos.jkt-1.neo.id/media.cinema21.co.id/movie-images/16MPRT.jpg',
      ageRating: 'D17',
      formatType: '2D',
    ),
    Movie(
      title: 'Badut Gendong',
      categoryMovie: 'Action, Horror',
      imageUrl: 'https://nos.jkt-1.neo.id/media.cinema21.co.id/movie-images/16BGEG.jpg',
      ageRating: 'D17',
      formatType: '2D',
    ),
  ];

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
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Movie Poster / Image Container
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    movie.imageUrl,
                    width: 75,
                    height: 105,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback placeholder widget if image fails to load
                      return Container(
                        width: 75,
                        height: 105,
                        color: const Color(0xFFE2E8F0),
                        child: const Icon(
                          Icons.movie_creation_outlined,
                          size: 32,
                          color: Color(0xFF94A3B8),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 75,
                        height: 105,
                        color: const Color(0xFFE2E8F0),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Movie Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        movie.categoryMovie,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Row of Badges (Age Rating & Format)
                      Row(
                        children: [
                          // Age Rating Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // We size the stack to fit the triangle nicely
                                const SizedBox(width: 26, height: 22),
                                Positioned(
                                  top: 0,
                                  child: ClipPath(
                                    clipper: TriangleClipper(),
                                    child: Container(
                                      width: 26,
                                      height: 22,
                                      color: const Color(0xFFFFEB3B), // Yellow/Amber
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
                          // Format Type Badge (e.g. 2D)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              movie.formatType,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF334155),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
