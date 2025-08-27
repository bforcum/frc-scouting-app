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
  Widget build(BuildContext context) {
    matchResults = ref.watch(storedMatchResultsProvider);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          spacing: 20,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Filter team number",
                hintStyle: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
            Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.start,
              children: matchResults.when(
                loading: () => [CircularProgressIndicator()],
                error:
                    (error, stack) => [Text("Something went wrong: \n$error")],
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
      ),
    );
  }
}
