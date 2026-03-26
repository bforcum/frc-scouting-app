import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberQuestionInput extends StatefulWidget {
  final Function(int?) onChanged;
  final String label;
  final int? initialValue;
  final int? min;
  final int? max;
  final String? hint;
  final String? errorText;

  const NumberQuestionInput({
    super.key,
    required this.label,
    required this.onChanged,
    this.min,
    this.max,
    this.hint,
    this.initialValue,
    this.errorText,
  });

  @override
  State<NumberQuestionInput> createState() => _NumberQuestionInputState();
}

class _NumberQuestionInputState extends State<NumberQuestionInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String _hintText = "";

  @override
  void initState() {
    super.initState();

    _hintText = widget.hint ?? "0";
    _controller.text = widget.initialValue?.toString() ?? "";

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _hintText = "";
      } else {
        _hintText = widget.hint ?? "0";
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.bodyMedium),
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

              if ((widget.min != null && (val < widget.min!)) ||
                  (widget.max != null && val > widget.max!)) {
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
                          ? ColorScheme.of(context).errorContainer
                          : ColorScheme.of(context).outline,
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
