import 'dart:math' as math;

import 'package:flutter/material.dart';

class CounterQuestionInput extends StatelessWidget {
  final Function(int) onChanged;
  final String label;
  final int min;
  final int max;
  final int? preset;
  final int stepSize;
  final int value;

  const CounterQuestionInput({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
    this.preset,
    this.stepSize = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const Spacer(),
        Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorScheme.of(context).outline,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 32,
                icon: Icon(Icons.horizontal_rule),

                onPressed:
                    (value <= min)
                        ? null
                        : () => onChanged(math.max(min, value - stepSize)),
              ),
              Container(
                width: 32,
                alignment: Alignment.center,
                child: Text(
                  '$value',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              IconButton(
                iconSize: 32,
                icon: Icon(Icons.add),
                onPressed:
                    (value >= max)
                        ? null
                        : () => onChanged(math.min(max, value + stepSize)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
