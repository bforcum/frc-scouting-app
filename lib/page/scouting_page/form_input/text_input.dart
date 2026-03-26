import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scouting_app/consts.dart';

class TextQuestionInput extends StatefulWidget {
  final Function(String)? onChanged;
  final String? hint;
  final String label;
  final bool big;
  final int length;
  final String? initialValue;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;

  const TextQuestionInput({
    super.key,
    required this.label,
    required this.length,
    this.big = true,
    this.hint,
    this.errorText,
    this.initialValue,
    this.onChanged,
    this.inputFormatters,
  });

  @override
  State<TextQuestionInput> createState() => _TextQuestionInputState();
}

class _TextQuestionInputState extends State<TextQuestionInput> {
  final _focusNode = FocusNode();
  String? _hintText = "";

  @override
  void initState() {
    super.initState();
    _hintText = widget.hint ?? "";

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _hintText = "";
      } else {
        _hintText = widget.hint;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: 10),
        TextFormField(
          minLines: 1,
          maxLines: widget.big ? null : 1,
          initialValue:
              (widget.initialValue != "") ? widget.initialValue : null,
          onChanged: widget.onChanged,
          focusNode: _focusNode,
          keyboardType: TextInputType.text,
          maxLength: widget.length,
          autocorrect: false,
          textAlign: TextAlign.left,
          textAlignVertical: TextAlignVertical.top,
          style: Theme.of(context).textTheme.bodyMedium,
          onTapOutside: (details) => _focusNode.unfocus(),
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(kBorderRadius),
            errorStyle: TextStyle(fontSize: 0),
            isCollapsed: false,
            isDense: false,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
              borderSide: BorderSide(
                color:
                    widget.errorText != null
                        ? ColorScheme.of(context).errorContainer
                        : ColorScheme.of(context).outline,
                width: 2,
              ),
            ),
            hintText: _hintText,
            hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).hintColor,
            ),
          ),
        ),
      ],
    );
  }
}
