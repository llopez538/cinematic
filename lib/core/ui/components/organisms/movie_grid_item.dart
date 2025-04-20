import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinematic/core/ui/components/atoms/gradient_overlay.dart';
import 'package:cinematic/core/ui/components/atoms/movie_info_row.dart';
import 'package:cinematic/models/film.dart';
import 'package:flutter/material.dart';

class MovieGridItem extends StatelessWidget {
  final Film movie;
  final VoidCallback? onTap;

  const MovieGridItem({super.key, required this.movie, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: movie.fullPosterPath,
              fit: BoxFit.cover,
              placeholder: (ctx, url) => Container(color: Colors.grey[800]),
              errorWidget:
                  (ctx, url, err) => Container(
                    color: Colors.grey[800],
                    child: const Icon(Icons.error, color: Colors.white),
                  ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.6, 0.95],
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  MovieInfoRow(movie: movie),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
