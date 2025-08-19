import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scouting_app/model/question.dart';

class NumberInput extends StatefulWidget {
  final Function(int?) onChanged;
  final QuestionNumber question;
  final int? initialValue;

  const NumberInput({
    super.key,
    required this.question,
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
  late final QuestionNumber question;
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String _hintText = "";

  @override
  void initState() {
    super.initState();
    question = widget.question;

    _hintText = question.hint ?? "0";
    _controller.text = widget.initialValue?.toString() ?? "";

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
            onChanged:
                (value) =>
                    widget.onChanged((value != "") ? int.parse(value) : null),
            controller: _controller,
            focusNode: _focusNode,
            onTap: () {
              _controller.selection = TextSelection(
                baseOffset: 0,
                extentOffset: _controller.text.length,
              );
            },
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (text) {
              if (text?.isEmpty ?? true) {
                return null;
              }
              int val = int.parse(text!);

              if ((question.min != null && (val < question.min!)) ||
                  (question.max != null && val > question.max!)) {
                return "";
              }
              return null;
            },
            onTapOutside: (event) {
              _focusNode.unfocus();
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
