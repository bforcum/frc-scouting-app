import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class FilterChipDropdown extends StatelessWidget {
  final List<String> labels;
  final List<bool> states;
  final ValueChanged<int> onToggle;
  final bool enabled;

  const FilterChipDropdown({
    super.key,
    required this.labels,
    required this.states,
    required this.onToggle,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color low =
        enabled
            ? ColorScheme.of(context).primaryContainer
            : Theme.of(context).highlightColor;
    final Color high =
        enabled
            ? ColorScheme.of(context).primary
            : ColorScheme.of(context).onSurface;
    final BoxDecoration decorOn = BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: low),
      color: low,
    );
    final BoxDecoration decorOff = BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: low),
      color: low.withAlpha(25),
    );
    final Color contentOff = high;
    final Color contentOn =
        enabled ? ColorScheme.of(context).onPrimaryContainer : high;

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
