import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/page/analysis_page.dart';
import 'package:scouting_app/page/scouting_page.dart';
import 'package:scouting_app/page/settings_page.dart';
import 'package:scouting_app/page/results_page.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.dark,
          dynamicSchemeVariant: DynamicSchemeVariant.rainbow,
          contrastLevel: 0.5,
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
            ScoutingPage(),
            ResultsPage(),
            AnalysisPage(),
            SettingsPage(),
          ][currentPage],
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.search), label: "Scouting"),
          NavigationDestination(icon: Icon(Icons.list), label: "Data"),
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
  share(title: "Share"),
  analysis(title: "Analysis"),
  settings(title: "Settings");

  const PageState({required this.title});

  final String title;
}
