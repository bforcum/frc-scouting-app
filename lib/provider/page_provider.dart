
import 'package:riverpod/riverpod.dart';

enum PageState {
	scouting(title: "Scouting"),
	share(title: "Share"),
	analysis(title: "Analysis"),
	settings(title: "Settings");

	const PageState ({required this.title});
	
	final String title;
}

final pageProvider = StateProvider<PageState>(
	(ref) => PageState.scouting
);