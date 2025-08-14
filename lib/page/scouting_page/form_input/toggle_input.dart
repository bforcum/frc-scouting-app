import 'package:flutter/material.dart';

class ToggleInput extends StatefulWidget {
  final Function(bool)? onChanged;
  final bool? preset;
  const ToggleInput({super.key, this.onChanged, this.preset});

  @override
  State<ToggleInput> createState() => _ToggleInputState();
}

class _ToggleInputState extends State<ToggleInput> {
  bool enabled = false;

  @override
  void initState() {
    super.initState();
    enabled = widget.preset ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: Switch(
        value: enabled,
        activeColor: Theme.of(context).colorScheme.primary,
        onChanged: (value) {
          setState(() {
            enabled = value;
          });
          if (widget.onChanged != null) widget.onChanged!(value);
        },
      ),
    );
  }
}
