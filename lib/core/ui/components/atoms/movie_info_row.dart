import 'package:cinematic/models/film.dart';
import 'package:flutter/material.dart';

class MovieInfoRow extends StatelessWidget {
  final Film movie;
  final Color color;

  const MovieInfoRow({
    super.key,
    required this.movie,
    this.color = Colors.white70,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            movie.releaseDate ?? 'N/A',
            style: TextStyle(
              fontSize: 10,
              color: color,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text('•', style: TextStyle(color: Colors.white70, fontSize: 10)),
        ),
        Flexible(
          child: Text(
            movie.originalLanguage?.toUpperCase() ?? 'N/A',
            style: TextStyle(
              fontSize: 10,
              color: color,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}