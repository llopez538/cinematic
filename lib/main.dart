import 'package:cinematic/models/film.dart';
import 'package:cinematic/providers/cinematic_provider.dart';
import 'package:cinematic/presentation/screens/detail_film_screen.dart';
import 'package:cinematic/presentation/screens/billboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => FilmProvider())],
      child: MaterialApp(
        title: 'Cinematic',
        theme: ThemeData(
          searchBarTheme: SearchBarThemeData(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.0), // Bordes cuadrados
              ),
            ),
            elevation: WidgetStateProperty.all(0),
          ),
        ),
        initialRoute: '/',
        routes: {'/': (context) => const BillboardScreen()},
        onGenerateRoute: (settings) {
          if (settings.name == '/details') {
            final film = settings.arguments as Film;

            return MaterialPageRoute(
              builder: (context) => DetailFilmScreen(film: film),
            );
          }
          return null;
        },
      ),
    );
  }
}
