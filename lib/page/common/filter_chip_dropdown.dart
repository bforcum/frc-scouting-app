import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class FilterChipDropdown extends StatelessWidget {
  final List<String> labels;
  final List<bool> states;
  final ValueChanged<int> onToggle;

  const FilterChipDropdown({
    super.key,
    required this.labels,
    required this.states,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final Color base = ColorScheme.of(context).primaryContainer;
    final BoxDecoration decorOn = BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: base),
      color: base,
    );
    final BoxDecoration decorOff = BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: base),
      color: base.withAlpha(25),
    );
    final Color contentOff = ColorScheme.of(context).primaryContainer;
    final Color contentOn = ColorScheme.of(context).onSurface;

    return Container(
      decoration: BoxDecoration(
        color: ColorScheme.of(context).surfaceContainerHigh,
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children:
            labels
                .mapIndexed(
                  (idx, label) => GestureDetector(
                    onTap: () {
                      debugPrint("Working");
                      onToggle(idx);
                    },
                    child: Container(
                      decoration: states[idx] ? decorOn : decorOff,
                      // padding: EdgeInsets.fromLTRB(8, 6, 8, 10),
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: (Text(
                        label,
                        textAlign: TextAlign.center,
                        style: TextTheme.of(context).bodySmall!.copyWith(
                          color: states[idx] ? contentOn : contentOff,
                        ),
                      )),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}
