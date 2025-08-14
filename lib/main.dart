import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/page/analysis_page.dart';
import 'package:scouting_app/page/scouting_page.dart';
import 'package:scouting_app/page/settings_page.dart';
import 'package:scouting_app/page/share_page.dart';
import 'package:scouting_app/provider/page_provider.dart';

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
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    int currentPage = ref.watch(pageProvider).index;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(ref.watch(pageProvider).title),
      ),
      body:
          [
            ScoutingPage(),
            SharePage(),
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
            (int index) =>
                ref.read(pageProvider.notifier).state = PageState.values[index],
      ),
    );
  }
}
