import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ven_smash/screens/screens.dart';
import 'package:ven_smash/services/services.dart';


void main() async{ 
  WidgetsFlutterBinding.ensureInitialized();
   runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TournamentServices())
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
         GlobalMaterialLocalizations.delegate
       ],
       supportedLocales: const [
         Locale('es'),
       ],
      debugShowCheckedModeBanner: false,
      title: 'VenSmash',
      initialRoute: '/home',
      routes: {
        //TODO: tutorial screen
        '/home': (_) => const HomeScreen(),
        '/tournamentData': (_) => const TournamentDataScreen(),
        '/search': (_) => const SearchTournamentScreen(),
        '/tournamentRequest':(_) => const TournamentDataRequestScreen(),
      },
      theme: ThemeData.dark(),
      builder: (context, child) { 
        return ScrollConfiguration(
          behavior: AppBehavior(),
          child: child!,
        );
      } 
    );
  }
}

class AppBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}