import 'package:flutter/material.dart';

class ToggleSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const ToggleSwitch({super.key, required this.value, required this.onChanged});

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch>
    with SingleTickerProviderStateMixin {
  late Animation<Alignment> _circleAnimation;
  late Animation<double> _animationValue;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      value: widget.value ? 1.0 : 0.0,
      vsync: this,
      duration: Duration(milliseconds: 140),
    );
    _circleAnimation = AlignmentTween(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeOutBack.flipped,
      ),
    );
    _animationValue = Tween<double>(begin: 0.0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeOutBack.flipped,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController.isCompleted) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
            widget.onChanged(!widget.value);
          },
          child: Container(
            width: 70.0,
            height: 48.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(
                color:
                    ColorTween(
                      begin: Theme.of(context).dividerColor,
                      end: Colors.transparent,
                    ).evaluate(_animationValue) ??
                    Theme.of(context).dividerColor,
                width: 2.0,
              ),
              color:
                  ColorTween(
                    begin:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    end: Theme.of(context).colorScheme.primaryContainer,
                  ).evaluate(_animationValue) ??
                  Colors.grey,
            ),
            child: Container(
              alignment: _circleAnimation.value,
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 4.0 + 6.0 * (1 - _animationValue.value),
                ),
                alignment: Alignment.center,
                width: _animationValue.value * 10.0 + 20.0,
                height: _animationValue.value * 10.0 + 20.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
