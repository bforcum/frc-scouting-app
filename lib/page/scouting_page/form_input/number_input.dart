import 'package:flutter/material.dart';

class NumberField extends StatefulWidget {
  final Function(String)? onChanged;
  final String? hintText;
  final int? min;
  final int? max;

  const NumberField({
    super.key,
    this.onChanged,
    this.hintText,
    this.min,
    this.max,
  });

  @override
  State<NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<NumberField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String _hintText = "";

  @override
  void initState() {
    super.initState();

    _hintText = widget.hintText ?? "0";

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _hintText = "";
      } else {
        _hintText = widget.hintText ?? "0";
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
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      child: TextFormField(
        onChanged: widget.onChanged,
        controller: _controller,
        focusNode: _focusNode,
        onTap: () {
          _controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controller.text.length,
          );
        },
        validator: (text) {
          if (text?.isEmpty ?? true) {
            return null;
          }
          int? val = int.tryParse(text!);
          if (val == null) {
            return "";
          }
          if ((widget.min != null && (val < widget.min!)) ||
              (widget.max != null && val > widget.max!)) {
            return "";
          }
          return null;
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
