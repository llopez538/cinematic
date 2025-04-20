import 'package:cinematic/core/ui/components/organisms/movie_grid_item.dart';
import 'package:cinematic/models/film.dart';
import 'package:flutter/material.dart';

class MoviesGrid extends StatelessWidget {
  final List<Film> movies;
  final ValueChanged<Film>? onMovieSelected;

  const MoviesGrid({
    super.key,
    required this.movies,
    this.onMovieSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => MovieGridItem(
            movie: movies[index],
            onTap: () => onMovieSelected?.call(movies[index]),
          ),
          childCount: movies.length,
        ),
      ),
    );
  }
}