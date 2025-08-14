import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final Function(String)? onChanged;
  final String? hintText;
  final int maxLength;

  const TextInput({
    super.key,
    this.onChanged,
    this.hintText = "0",
    this.maxLength = 50,
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  final _focusNode = FocusNode();
  String _hintText = "";

  @override
  void initState() {
    super.initState();

    _hintText = widget.hintText ?? "";

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _hintText = "";
      } else {
        _hintText = widget.hintText ?? "";
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      width: 154,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      child: TextField(
        onChanged: widget.onChanged,
        focusNode: _focusNode,
        keyboardType: TextInputType.multiline,
        maxLength: widget.maxLength,
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
