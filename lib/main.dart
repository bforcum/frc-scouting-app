import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/page/analysis_page.dart';
import 'package:scouting_app/page/scouting_page.dart';
import 'package:scouting_app/page/settings_page.dart';
import 'package:scouting_app/page/results_page.dart';

final GlobalKey homeKey = GlobalKey();

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FRC SAASquatch Scouting',
      theme: ThemeData(
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.w800),
          displayMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
          displaySmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
          headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          titleLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
          titleMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          titleSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          bodyLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
          bodyMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          bodySmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: kBrightness,
          dynamicSchemeVariant: DynamicSchemeVariant.rainbow,
          // contrastLevel: 1,
          contrastLevel: (kBrightness == Brightness.light) ? 0.5 : 0,
        ),
        // brightness: Brightness.dark,
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
