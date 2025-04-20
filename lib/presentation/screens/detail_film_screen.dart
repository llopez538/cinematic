import 'package:cinematic/core/ui/components/atoms/primary_button.dart';
import 'package:cinematic/core/ui/components/atoms/title_section.dart';
import 'package:cinematic/core/ui/components/molecules/metadata_row.dart';
import 'package:cinematic/core/ui/components/organisms/action_buttons_row.dart';
import 'package:cinematic/core/ui/components/organisms/play_button_row.dart';
import 'package:cinematic/core/ui/templates/detail_film_template.dart';
import 'package:cinematic/models/film.dart';
import 'package:cinematic/providers/cinematic_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';// Asegúrate de importar tu provider

class DetailFilmScreen extends StatefulWidget {
  static const routeName = '/details';
  final Film film; // Cambiado de Film a int ya que _getDetailFilm espera un filmId
  const DetailFilmScreen({super.key, required this.film});


  @override
  State<DetailFilmScreen> createState() => _DetailFilmScreenState();
}

class _DetailFilmScreenState extends State<DetailFilmScreen> {
  Film? singleFilm;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFilmDetails();
  }

  Future<void> _loadFilmDetails() async {
    setState(() => isLoading = true);
    try {
      final filmProvider = Provider.of<FilmProvider>(context, listen: false);
      print(widget.film.id);
      await filmProvider.getDetailFilm(widget.film.id);
      setState(() => singleFilm = filmProvider.singleFilm);
    } catch (e) {
      // Manejar el error adecuadamente
      print('Error loading film details: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (singleFilm == null) {
      return const Center(child: Text('Película no encontrada'));
    }

    return DetailFilmTemplate(
      film: singleFilm!,
      content: [const SizedBox(height: 20), _buildContent()],
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleSection(film: singleFilm!),
          const SizedBox(height: 8),
          MetadataRow(
            items: [
              singleFilm!.releaseDate?.substring(0, 4) ?? 'N/A', // Año
              // singleFilm!.genres?.join(', ') ?? 'N/A', // Géneros
              'Temporada 4', // Esto debería venir de los datos de la película/serie
              // singleFilm!.director ?? 'Director desconocido',
            ],
          ),
          const SizedBox(height: 20),
          _buildDescription(),
          const SizedBox(height: 30),
          const ActionButtonsRow(),
          const SizedBox(height: 30),
          PrimaryButton(text: 'Comenzar a ver', onPressed: () => _handlePlay()),
          const SizedBox(height: 20),
          const PlayButtonRow(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _handlePlay() {
    // Implementa la lógica para reproducir la película
  }

  Widget _buildDescription() {
    return Text(
      singleFilm!.overview,
      style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
      textAlign: TextAlign.justify,
    );
  }
}