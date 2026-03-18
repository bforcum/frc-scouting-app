import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/page/analysis_page/analysis_details/analysis_table.dart';

class AnalysisPage extends ConsumerStatefulWidget {
  const AnalysisPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends ConsumerState<AnalysisPage> {
  String searchText = "";
  bool filtersVisible = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: ColorScheme.of(context).surfaceContainerHigh,
          padding: const EdgeInsets.all(12),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 60,
                child: Flex(
                  direction: Axis.horizontal,
                  spacing: 10,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          fillColor:
                              ColorScheme.of(context).surfaceContainerLow,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(kBorderRadius),
                          ),
                          hintText: "Team number",
                          hintStyle: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(color: Theme.of(context).hintColor),
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged:
                            (value) => setState(() => searchText = value),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed:
                    () => setState(() {
                      filtersVisible = !filtersVisible;
                    }),
                label: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("Filters", textAlign: TextAlign.center),
                ),
                icon: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    filtersVisible
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                  ),
                ),
                iconAlignment: IconAlignment.end,
              ),
            ],
          ),
        ),
        AnalysisTable(),
      ],
    );
  }
}
