import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/page/results_page/match_result_card.dart';
import 'package:scouting_app/provider/stored_results_provider.dart';

class AnalysisPage extends ConsumerStatefulWidget {
  const AnalysisPage({super.key});

  @override
  ConsumerState<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends ConsumerState<AnalysisPage> {
  String searchText = "";
  SortType sortBy = SortType.values[0];
  List<String> sortOptions = [];

  @override
  Widget build(BuildContext context) {
    var indices = ref.watch(ResultIndicesProvider(sortBy, searchText));

    return Stack(
      fit: StackFit.expand,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              padding: const EdgeInsets.all(20),
              child: Column(
                spacing: 20,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search by team number",
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => setState(() => searchText = value),
                  ),
                  DropdownMenu<SortType>(
                    width: MediaQuery.of(context).size.width,
                    label: Text("Sort by"),
                    initialSelection: sortBy,
                    requestFocusOnTap: false,
                    keyboardType: TextInputType.none,
                    enableSearch: false,
                    dropdownMenuEntries: [
                      for (int i = 0; i < sortOptions.length; i++)
                        DropdownMenuEntry(value: SortType.values[i], label: sortOptions[i]),
                    ],

                    onSelected: (val) {
                      setState(() {
                        sortBy = val ?? SortType.values[0];
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Builder(builder: (context) {
                if (indices.hasError) {
                  return Text("Error encountered: ${indices.error}");
                }
                if (indices.hasValue) {
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 90),
                    itemCount: indices.value?.length ?? 0,
                    itemBuilder: (context, index) {
                      MatchResult? result = ref
                          .read(storedResultsProvider.notifier)
                          .getResult(indices.value![index]);
                      if (result == null) {
                        return SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: MatchResultCard(result: result)
                      );
                    },
                  );
                }
                return SizedBox.shrink(child: CircularProgressIndicator());
              },)
            ),
          ],
        ),
      ],
    );
  }
}