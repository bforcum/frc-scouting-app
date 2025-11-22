import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scouting_app/model/question.dart';

class NumberInput extends StatefulWidget {
  final Function(int?) onChanged;
  final QuestionNumber question;
  final int? initialValue;
  final String? errorText;

  const NumberInput({
    super.key,
    required this.question,
    required this.onChanged,
    this.initialValue,
    this.errorText,
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
        Text(question.label, style: Theme.of(context).textTheme.bodyMedium),
        Spacer(),
        Container(
          // clipBehavior: Clip.hardEdge,
          width: 120,
          height: 48,
          alignment: Alignment.topCenter,
          child: TextFormField(
            maxLength: 5,
            maxLines: 1,

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
            style: Theme.of(context).textTheme.bodyMedium,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              errorStyle: TextStyle(fontSize: 0),
              isCollapsed: false,
              isDense: false,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
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
              counterText: "",
            ),
          ),
        ),
      ],
    );
  }
}
