import 'package:flutter/material.dart';

class CounterInput extends StatefulWidget {
  final Function(int)? onChanged;
  final int? min;
  final int? max;
  final int? preset;
  const CounterInput({
    super.key,
    this.onChanged,
    this.min,
    this.max,
    this.preset,
  });

  @override
  State<CounterInput> createState() => _CounterInputState();
}

class _CounterInputState extends State<CounterInput> {
  int count = 0;

  @override
  void initState() {
    super.initState();
    count = widget.preset ?? widget.min ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.horizontal_rule, size: 40),

            onPressed:
                (widget.min != null && count <= widget.min!)
                    ? null
                    : () => setState(() {
                      count -= 1;
                      if (widget.onChanged != null) widget.onChanged!(count);
                    }),
          ),
          Container(
            width: 40,
            alignment: Alignment.center,
            child: Text(
              '$count',
              style: TextStyle(fontSize: 25, fontFamily: "Roboto"),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add, size: 40),
            onPressed:
                (widget.max != null && count >= widget.max!)
                    ? null
                    : () => setState(() {
                      count += 1;
                      if (widget.onChanged != null) widget.onChanged!(count);
                    }),
          ),
        ],
      ),
    );
  }
}
