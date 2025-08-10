import 'package:flutter/material.dart';

enum FieldType { text, number, counter, dropdown, barSelect, toggle }

class CustomField extends StatelessWidget {
  final Widget inputField;
  final String label;

  CustomField.counter({
    super.key,
    required this.label,
    Function(int)? onChanged,
    int? min,
    int? max,
    int? start,
  }) : inputField = _CounterField(
         key: UniqueKey(),
         onChanged: onChanged,
         min: min,
         max: max,
         start: start,
       );

  CustomField.number({
    super.key,
    required this.label,
    onChanged,
    int? min,
    int? max,
    String hintText = "0",
  }) : inputField = _NumberField(
         key: UniqueKey(),
         onChanged: onChanged,
         hintText: hintText,
       );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 25)),
        Spacer(),
        inputField,
      ],
    );
  }
}

class _NumberField extends StatefulWidget {
  final Function(String)? onChanged;
  final String hintText;

  const _NumberField({super.key, this.onChanged, this.hintText = "0"});

  @override
  State<_NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<_NumberField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String _hintText = "";

  @override
  void initState() {
    super.initState();

    _hintText = widget.hintText;

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _hintText = "";
      } else {
        _hintText = widget.hintText;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      width: 154,
      height: 58,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: TextField(
        onChanged: widget.onChanged,
        controller: _controller,
        focusNode: _focusNode,
        onTap: () {
          _controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controller.text.length,
          );
        },
        keyboardType: TextInputType.number,
        autocorrect: false,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 25),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: _hintText,
          hintStyle: TextStyle(
            fontSize: 25,
            color: Theme.of(context).hintColor,
          ),
        ),
      ),
    );
  }
}

class _CounterField extends StatefulWidget {
  final Function(int)? onChanged;
  final int? min;
  final int? max;
  final int? start;
  const _CounterField({
    super.key,
    this.onChanged,
    this.min,
    this.max,
    this.start = 0,
  });

  @override
  State<_CounterField> createState() => _CounterFieldState();
}

class _CounterFieldState extends State<_CounterField> {
  int count = 0;

  @override
  void initState() {
    super.initState();
    count = widget.start ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.all(Radius.circular(40)),
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
