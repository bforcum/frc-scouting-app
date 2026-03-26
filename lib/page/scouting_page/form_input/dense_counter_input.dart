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
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        debugPrint("Test");
        if (details.primaryVelocity == null) return;
        if (details.primaryVelocity! > 20.0 && value < max) {
          onChanged(math.min(max, value + stepSize));
        } else if (details.primaryVelocity! < -20.0 && value > min) {
          onChanged(math.max(min, value - stepSize));
        }
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: ColorScheme.of(context).outline, width: 2),
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Expanded(
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_left,
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
                    Icons.arrow_right,
                    size: 20,
                    color:
                        value >= max ? Theme.of(context).disabledColor : null,
                  ),
                ],
              ),
              // Row(
              //   mainAxisSize: MainAxisSize.max,
              //   children: [
              //     GestureDetector(),
              //     Expanded(child: GestureDetector()),
              //     Expanded(child: GestureDetector()),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
