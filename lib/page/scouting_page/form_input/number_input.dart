import 'package:flutter/material.dart';
import 'package:scouting_app/model/question.dart';

class NumberField extends StatefulWidget {
  final Function(String)? onChanged;
  final QuestionNumber question;

  const NumberField({super.key, required this.question, this.onChanged});

  @override
  State<NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<NumberField> {
  late final QuestionNumber question;
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String _hintText = "";

  @override
  void initState() {
    super.initState();
    question = widget.question;

    _hintText = question.hint ?? "0";

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _hintText = "";
      } else {
        _hintText = question.hint ?? "0";
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(question.label, style: TextStyle(fontSize: 25)),
        Spacer(),
        Container(
          clipBehavior: Clip.hardEdge,
          width: 154,
          height: 60,
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
              if ((question.min != null && (val < question.min!)) ||
                  (question.max != null && val > question.max!)) {
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
        ),
      ],
    );
  }
}
