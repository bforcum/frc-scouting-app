import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scouting_app/page/analysis_page.dart';
import 'package:scouting_app/page/scouting_page.dart';
import 'package:scouting_app/page/settings_page.dart';
import 'package:scouting_app/page/results_page.dart';
import 'package:scouting_app/provider/directory_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scouting_app/provider/settings_provider.dart';

final GlobalKey homeKey = GlobalKey();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPrefs = await SharedPreferences.getInstance();

  final dir = kIsWeb ? null : await getApplicationSupportDirectory();
  if (dir != null && !await dir.exists()) {
    await dir.create(recursive: true);
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
        appDirectoryProvider.overrideWithValue(dir),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = TextTheme(
      displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.w800),
      displayMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
      displaySmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
      titleLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
      titleSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    );
    return MaterialApp(
      title: 'FRC SAASquatch Scouting',
      themeMode: ref.watch(settingsProvider).themeMode,
      theme: ThemeData(
        textTheme: textTheme,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.light,
          dynamicSchemeVariant: DynamicSchemeVariant.rainbow,
          contrastLevel: 0.5,
        ).copyWith(
          surface: Colors.grey[300],
          surfaceContainerLowest: Colors.grey[300],
          surfaceContainerLow: Colors.grey[300],
          surfaceContainer: Colors.grey[200],
          surfaceContainerHigh: Colors.grey[100],
          surfaceContainerHighest: Colors.white,
        ),

        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        textTheme: textTheme,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.dark,
          dynamicSchemeVariant: DynamicSchemeVariant.rainbow,
          contrastLevel: 0,
        ),
        brightness: Brightness.dark,
      ),
      home: const App(),
    );
  }
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(PageState.values[currentPage].title),
      ),
      body:
          [
            ScoutingPage(key: homeKey),
            ResultsPage(key: homeKey),
            AnalysisPage(key: homeKey),
            SettingsPage(key: homeKey),
          ][currentPage],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        destinations: [
          NavigationDestination(icon: Icon(Icons.search), label: "Scouting"),
          NavigationDestination(icon: Icon(Icons.list), label: "Results"),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: "Analysis"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
        ],
        selectedIndex: currentPage,
        onDestinationSelected:
            (int index) => setState(() => currentPage = index),
      ),
    );
  }
}

enum PageState {
  scouting(title: "Scouting"),
  results(title: "Results"),
  analysis(title: "Analysis"),
  settings(title: "Settings");

  const PageState({required this.title});

  final String title;
}
