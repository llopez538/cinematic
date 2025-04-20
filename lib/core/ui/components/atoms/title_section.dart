import 'package:cinematic/models/film.dart';
import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({
    super.key,
    required this.film,
  });

  final Film film;

  @override
  Widget build(BuildContext context) {
    return Text(
      film.title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}