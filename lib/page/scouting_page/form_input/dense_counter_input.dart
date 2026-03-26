import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:scouting_app/consts.dart';

class DenseCounterInput extends StatelessWidget {
  final Function(int) onChanged;
  final int min;
  final int max;
  final int? preset;
  final int stepSize;
  final int value;

  const DenseCounterInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 255,
    this.preset,
    this.stepSize = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(color: ColorScheme.of(context).outline, width: 2),
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Expanded(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove,
                    size: 20,
                    color:
                        value <= min ? Theme.of(context).disabledColor : null,
                  ),
                  Container(
                    width: 24,
                    alignment: Alignment.center,
                    child: Text(
                      value.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Icon(
                    Icons.add,
                    size: 20,
                    color:
                        value >= max ? Theme.of(context).disabledColor : null,
                  ),
                ],
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () => onChanged(math.max(min, value - stepSize)),
                      child: Container(
                        width: constraints.maxWidth / 2,
                        height: 44,
                        color: Color.fromARGB(32, 32, 32, 32),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => onChanged(math.min(max, value + stepSize)),
                      child: Container(
                        width: constraints.maxWidth / 2,
                        height: 44,
                        color: Color.fromARGB(32, 32, 32, 32),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
