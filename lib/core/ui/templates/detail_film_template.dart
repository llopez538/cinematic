import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinematic/models/film.dart';
import 'package:flutter/material.dart';

class DetailFilmTemplate extends StatelessWidget {
  final Film film;
  final List<Widget> content;

  const DetailFilmTemplate({
    super.key,
    required this.film,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: film.fullBackdropPath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            placeholder: (context, url) => Container(
              color: Colors.grey[800],
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[800],
              child: const Icon(Icons.error, color: Colors.white),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.9),
                ],
                stops: const [0.4, 0.7, 1.0],
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: content,
              ),
            ),
          ),
        ],
      ),
    );
  }
}