import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:cinematic/models/film.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class FilmProvider extends ChangeNotifier {
  final List<Film> _movies = [];
  late Film singleFilm;
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  String? _error;
  bool _hasMore = true;
  bool _isUsingCache = false;

  List<Film> get movies => List.unmodifiable(_movies);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;
  bool get isUsingCache => _isUsingCache;

  static const _baseUrl = 'https://api.themoviedb.org/3/discover/movie';
  static const _apiKey = 'Your_API_Key';
  static const _headers = {
    'accept': 'application/json',
    'Authorization': 'Bearer $_apiKey',
  };

  // Database variables
  static Database? _database;
  static const String _dbName = 'films_cache.db';
  static const String _tableName = 'cached_films';
  static const int _maxCachedPages = 5; // Maximum number of pages to cache

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY,
            page INTEGER,
            data TEXT,
            genre INTEGER,
            timestamp INTEGER
          )
        ''');
      },
    );
  }

  Future<bool> _hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> loadMovies({bool refresh = false, int genre = 16}) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      _error = null;
      _isUsingCache = false;

      if (refresh) {
        _currentPage = 1;
        _movies.clear();
        _hasMore = true;
      }

      if (!_hasMore) return;

      final hasInternet = await _hasInternetConnection();

      if (hasInternet) {
        // Load from API
        final uri = Uri.parse(
          '$_baseUrl?'
          'include_adult=true&'
          'include_video=false&'
          'language=en-US&'
          'page=$_currentPage&'
          'sort_by=popularity.desc&'
          'with_genres=$genre',
        );

        final response = await http.get(uri, headers: _headers);

        if (response.statusCode != 200) {
          throw Exception('API Error: ${response.statusCode}');
        }

        final data = json.decode(response.body) as Map<String, dynamic>;
        _currentPage = data['page'] as int;
        _totalPages = data['total_pages'] as int;
        _hasMore = _currentPage < _totalPages;

        final results =
            (data['results'] as List)
                .map((json) => Film.fromJson(json as Map<String, dynamic>))
                .toList();

        _movies.addAll(results);

        notifyListeners();

        // Cache the results
        await _cachePageResults(_currentPage, genre, response.body);
      } else {
        // Load from cache
        _isUsingCache = true;
        final cachedResults = await _getCachedPageResults(_currentPage, genre);

        if (cachedResults != null) {
          final data = json.decode(cachedResults) as Map<String, dynamic>;
          _currentPage = data['page'] as int;
          _totalPages = data['total_pages'] as int;
          _hasMore = _currentPage < _totalPages;

          final results =
              (data['results'] as List)
                  .map((json) => Film.fromJson(json as Map<String, dynamic>))
                  .toList();

          _movies.addAll(results);

          notifyListeners();
        } else {
          throw Exception(
            'No internet connection and no cached data available',
          );
        }
      }
    } catch (e) {
      _error = e.toString();
      // If error occurs, try to load from cache if not already doing so
      if (!_isUsingCache) {
        try {
          final cachedResults = await _getCachedPageResults(
            _currentPage,
            genre,
          );
          if (cachedResults != null) {
            _isUsingCache = true;
            final data = json.decode(cachedResults) as Map<String, dynamic>;
            final results =
                (data['results'] as List)
                    .map((json) => Film.fromJson(json as Map<String, dynamic>))
                    .toList();
            _movies.addAll(results);
            _error = null; // Clear error if cache load succeeds
          }
        } catch (cacheError) {
          // If cache also fails, keep the original error
        }
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getDetailFilm(int filmId) async {
  if (_isLoading) return;

  try {
    _isLoading = true;
    _error = null;
    _isUsingCache = false;

    final hasInternet = await _hasInternetConnection();

    if (hasInternet) {
      // Construir la URL para la película específica
      final uri = Uri.parse('https://api.themoviedb.org/3/movie/$filmId');

      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        singleFilm = Film.fromJson(data);
        
      } else {
        throw Exception('Error al obtener los detalles de la película');
      }
    } else {
      // Intentar cargar desde caché si no hay conexión
      _isUsingCache = true;

    }
  } catch (e) {
    _error = e.toString();
    
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  Future<void> _cachePageResults(int page, int genre, String data) async {
    final db = await database;
    await db.insert(_tableName, {
      'page': page,
      'data': data,
      'genre': genre,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    // Clean up old cache entries
    await _cleanupCache();
  }

  Future<void> _cleanupCache() async {
    final db = await database;
    // Get all cached entries ordered by timestamp (oldest first)
    final entries = await db.query(_tableName, orderBy: 'timestamp ASC');

    // If we have more than max allowed, delete the oldest ones
    if (entries.length > _maxCachedPages) {
      final idsToDelete =
          entries
              .sublist(0, entries.length - _maxCachedPages)
              .map((e) => e['id'] as int)
              .toList();

      await db.delete(
        _tableName,
        where: 'id IN (${List.filled(idsToDelete.length, '?').join(',')})',
        whereArgs: idsToDelete,
      );
    }
  }

  Future<String?> _getCachedPageResults(int page, int genre) async {
    final db = await database;
    final results = await db.query(
      _tableName,
      where: 'page = ? AND genre = ?',
      whereArgs: [page, genre],
      orderBy: 'timestamp DESC',
      limit: 1,
    );

    if (results.isNotEmpty) {
      return results.first['data'] as String;
    }
    return null;
  }

  Future<void> loadNextPage() async {
    if (_hasMore && !_isLoading) {
      _currentPage++;
      await loadMovies();
    }
  }

  void clear() {
    _movies.clear();
    _currentPage = 1;
    _totalPages = 1;
    _hasMore = true;
    _error = null;
    _isUsingCache = false;
    notifyListeners();
  }

  // Close the database when done
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
