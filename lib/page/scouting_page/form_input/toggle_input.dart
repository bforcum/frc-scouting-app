import 'package:flutter/material.dart';
import 'package:scouting_app/model/question.dart';

class ToggleInput extends StatelessWidget {
  final Function(bool) onChanged;
  final bool? value;
  final QuestionToggle question;

  const ToggleInput({
    super.key,
    required this.question,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(question.label, style: Theme.of(context).textTheme.bodyMedium),
        Spacer(),
        SizedBox(
          height: 48,
          child: _CustomSwitch(
            value: value ?? question.preset ?? false,
            onChanged: (value) {
              onChanged(value);
            },
          ),
        ),
      ],
    );
  }
}

class _CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _CustomSwitch({required this.value, required this.onChanged});

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<_CustomSwitch>
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
            width: 80,
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
