import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/page/analysis_page.dart';
import 'package:scouting_app/page/common/custom_navigation_bar.dart';
import 'package:scouting_app/page/scouting_page.dart';
import 'package:scouting_app/page/settings_page.dart';
import 'package:scouting_app/page/results_page.dart';
import 'package:scouting_app/provider/directory_provider.dart';
import 'package:scouting_app/theme.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FRC SAASquatch Scouting',
      themeMode: ref.watch(settingsProvider).themeMode,
      theme: ThemeData(
        textTheme: getAppTextTheme(Brightness.light),
        colorScheme: getAppColorScheme(Brightness.light),
        brightness: Brightness.light,
        buttonTheme: getAppButtonTheme(Brightness.light),
      ),
      darkTheme: ThemeData(
        textTheme: getAppTextTheme(Brightness.dark),
        colorScheme: getAppColorScheme(Brightness.dark),
        brightness: Brightness.dark,
        // filledButtonTheme: FilledButtonThemeData(style: kButtonStyle),
        textButtonTheme: TextButtonThemeData(style: kButtonStyle),
        elevatedButtonTheme: ElevatedButtonThemeData(style: kButtonStyle),
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

    debugPrint(
      ColorScheme.of(context).inversePrimary.toARGB32().toRadixString(16),
    );
    debugPrint(
      ColorScheme.of(context).primaryContainer.toARGB32().toRadixString(16),
    );
    debugPrint(
      ColorScheme.of(context).primaryFixedDim.toARGB32().toRadixString(16),
    );
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
      bottomNavigationBar: CustomNavigationBar(
        destinationIcons: [
          Icons.search,
          Icons.list_alt_rounded,
          Icons.bar_chart,
          Icons.settings,
        ],
        destinationLabels: ["Scouting", "Results", "Analysis", "Settings"],
        selectedIndex: currentPage,
        onDestinationSelected:
            (int index) => setState(() => currentPage = index),
        // backgroundColor:
        //     Theme.brightnessOf(context) == Brightness.light
        //         ? ColorScheme.of(context).inversePrimary
        //         : null,
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
