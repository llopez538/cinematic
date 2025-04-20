import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinematic/models/film.dart';
import 'package:flutter/material.dart';

class MainCarousel extends StatelessWidget {
  final List<Film> films;
  final ValueChanged<Film>? onFilmSelected;

  const MainCarousel({
    super.key,
    required this.films,
    this.onFilmSelected, 
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: films.length,
          itemBuilder: (context, index) => _CarouselItem(
            film: films[index],
            onTap: () => onFilmSelected?.call(films[index]),
          ),
        ),
      ),
    );
  }
}

class _CarouselItem extends StatelessWidget {
  final Film film;
  final VoidCallback? onTap;

  const _CarouselItem({required this.film, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: film.fullBackdropPath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                placeholder: (ctx, url) => Container(color: Colors.grey[800]),
                errorWidget: (ctx, url, err) => Container(
                  color: Colors.grey[800],
                  child: const Icon(Icons.error, color: Colors.white),
                ),
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
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  film.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}