import 'package:flutter/material.dart';

class MatchResultField extends StatelessWidget {
  final String label, value;
  final bool big;
  final String? hint;

  const MatchResultField({
    super.key,
    required this.label,
    required this.value,
    this.hint,
    this.big = false,
  });

  @override
  Widget build(BuildContext context) {
    if (big) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium!),
          SizedBox(height: 10),
          Container(
            clipBehavior: Clip.hardEdge,
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              border: Border.all(
                color: ColorScheme.of(context).outline,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child:
                  (value.isEmpty && hint != null)
                      ? Text(
                        hint!,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                      )
                      : Text(
                        value,
                        style: Theme.of(context).textTheme.bodySmall!,
                      ),
            ),
          ),
        ],
      );
    }
    return Row(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium!),
        const Spacer(),
        Container(
          width: 120,
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorScheme.of(context).outline,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          alignment: Alignment.center,
          child:
              (value.isEmpty && hint != null)
                  ? Text(
                    hint!,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                  )
                  : Text(value, style: Theme.of(context).textTheme.bodyMedium!),
        ),
      ],
    );
  }
}
