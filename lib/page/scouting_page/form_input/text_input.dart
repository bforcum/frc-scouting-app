import 'package:flutter/material.dart';
import 'package:scouting_app/model/question.dart';

class TextInput extends StatefulWidget {
  final Function(String)? onChanged;
  final QuestionText question;
  final String? initialValue;
  final FormFieldState<String> formState;

  const TextInput({
    super.key,
    required this.question,
    required this.formState,
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
        Text(question.label, style: TextStyle(fontSize: 25)),
        SizedBox(height: 10),
        Container(
          clipBehavior: Clip.hardEdge,
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  widget.formState.errorText != null
                      ? Theme.of(context).colorScheme.errorContainer
                      : Theme.of(context).colorScheme.outline,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: TextFormField(
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
              style: TextStyle(fontSize: 20),
              onTapOutside: (details) => _focusNode.unfocus(),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: _hintText,
                hintStyle: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
