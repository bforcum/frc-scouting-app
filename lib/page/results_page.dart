import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/page/results_page/match_result_card.dart';
import 'package:scouting_app/provider/match_result_provider.dart';

class ResultsPage extends ConsumerStatefulWidget {
  const ResultsPage({super.key});

  @override
  ConsumerState<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends ConsumerState<ResultsPage> {
  late AsyncValue<List<MatchResult>> matchResults;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    matchResults = ref.watch(storedMatchResultsProvider);
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text("Match Results"),
          TextField(
            decoration: InputDecoration(
              hintText: "Filter results",
              hintStyle: TextStyle(
                fontSize: 20,
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
          Column(
            children: matchResults.when(
              loading: () => [CircularProgressIndicator()],
              error: (error, stack) => [Text("Something went wrong: \n$error")],
              data: (results) {
                if (results.isEmpty) return [Text("No results yet")];
                return results
                    .map((e) => MatchResultCard(matchResult: e))
                    .toList();
              },
            ),
          ),
        ],
      ),
    );
  }
}
