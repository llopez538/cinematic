import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinematic/core/ui/components/atoms/search_input.dart';
import 'package:cinematic/core/ui/components/molecules/error_view.dart';
import 'package:cinematic/core/ui/components/molecules/loading_footer.dart';
import 'package:cinematic/core/ui/components/molecules/main_carousel.dart';
import 'package:cinematic/core/ui/components/molecules/no_more_items.dart';
import 'package:cinematic/core/ui/components/organisms/favorites_section.dart';
import 'package:cinematic/core/ui/components/organisms/movies_grid.dart';
import 'package:cinematic/core/ui/templates/billboard_template.dart';
import 'package:cinematic/presentation/screens/detail_film_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cinematic/models/film.dart';
import 'package:cinematic/providers/cinematic_provider.dart';

class BillboardScreen extends StatefulWidget {
  static const routeName = '/billboard';

  const BillboardScreen({super.key});

  @override
  State<BillboardScreen> createState() => _BillboardScreenState();
}

class _BillboardScreenState extends State<BillboardScreen> {
  final ScrollController _scrollController = ScrollController();
  final double _scrollThreshold = 200;
  final TextEditingController _searchController = TextEditingController();
  late FilmProvider _filmProvider;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _filmProvider =
        context.read<FilmProvider>(); 
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      await _filmProvider.loadMovies(refresh: true);
      if (mounted) {
        setState(() => _searchController.clear());
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: ${e.toString()}')),
        );
      }
    }
  }

  void _onSearchChanged(String query) => setState(() {});

  List<Film> _searchList(List<Film> filmList) =>
      filmList
          .where(
            (film) =>
                film.title.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ) ||
                film.originalTitle.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ),
          )
          .toList();

  void _onScroll() {
    if (!_scrollController.hasClients) return; // Protección adicional

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= _scrollThreshold) {
      _filmProvider.loadNextPage(); // Usamos la referencia local
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredFilm = _searchList(_filmProvider.movies);

    return BillboardTemplate(
      title: 'Cinematic Billboard',
      onRefresh: _loadInitialData,
      scrollController: _scrollController, // Asegurar paso del controller
      slivers: [
        if (_filmProvider.isLoading)
          const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_filmProvider.error != null)
          SliverToBoxAdapter(
            child: ErrorView(
              message: _filmProvider.error!,
              onRetry: _loadInitialData,
            ),
          )
        else ...[
          MainCarousel(
            films: _filmProvider.movies.reversed.toList(),
            onFilmSelected: _navigateToDetail,
          ),
          _buildSearchSection(),
          const FavoritesSection(),
          MoviesGrid(movies: filteredFilm, onMovieSelected: _navigateToDetail),
          _buildFooter(filteredFilm),
        ],
      ],
    );
  }

  Widget _buildFooter(List<Film> filteredFilm) {
    if (_filmProvider.isLoading) return const SliverLoadingFooter();
    if (!_filmProvider.hasMore || filteredFilm.isEmpty) {
      return const SliverNoMoreItems();
    }
    return const SliverToBoxAdapter();
  }

  Widget _buildSearchSection() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverToBoxAdapter(
        child: SearchInput(
          controller: _searchController,
          onChanged: _onSearchChanged,
        ),
      ),
    );
  }

  void _navigateToDetail(Film film) {
    Navigator.pushNamed(context, DetailFilmScreen.routeName, arguments: film);
  }
}
