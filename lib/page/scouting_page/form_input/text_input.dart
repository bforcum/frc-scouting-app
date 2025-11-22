import 'package:flutter/material.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/question.dart';

class TextInput extends StatefulWidget {
  final Function(String)? onChanged;
  final QuestionText question;
  final String? initialValue;
  final String? errorText;

  const TextInput({
    super.key,
    required this.question,
    this.errorText,
    this.initialValue,
    this.onChanged,
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  late final QuestionText question;

  final _focusNode = FocusNode();
  String _hintText = "";

  @override
  void initState() {
    super.initState();

    question = widget.question;
    _hintText = question.hint ?? "";

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _hintText = "";
      } else {
        _hintText = question.hint ?? "";
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question.label, style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: 10),
        TextFormField(
          minLines: 1,
          maxLines: widget.question.multiline ? null : 1,
          initialValue:
              (widget.initialValue != "") ? widget.initialValue : null,
          onChanged: widget.onChanged,
          focusNode: _focusNode,
          keyboardType: TextInputType.text,
          maxLength: question.length,
          autocorrect: false,
          textAlign: TextAlign.left,
          textAlignVertical: TextAlignVertical.top,
          style: Theme.of(context).textTheme.bodyMedium,
          onTapOutside: (details) => _focusNode.unfocus(),
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
                        ? Theme.of(context).colorScheme.errorContainer
                        : Theme.of(context).colorScheme.outline,
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
