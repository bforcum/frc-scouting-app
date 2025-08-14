import 'package:flutter/material.dart';
import 'package:scouting_app/model/question.dart';

enum FieldType { text, number, counter, dropdown, barSelect, toggle }

class CustomField extends StatelessWidget {
  final Widget inputField;
  final String label;

  const CustomField._(this.label, this.inputField);

  factory CustomField.fromQuestion(Question question) {
    switch (question.type) {
      case QuestionType.binary:
      case QuestionType.counter:
        question = question as QuestionCounter;
        return CustomField._(
          question.label,
          _CounterField(
            key: UniqueKey(),
            min: question.min,
            max: question.max,
            preset: question.preset,
          ),
        );
      case QuestionType.dropdown:
      case QuestionType.number:
        question = question as QuestionNumber;
        return CustomField._(
          question.label,
          _NumberField(
            key: UniqueKey(),
            hintText: question.hint,
            min: question.min,
            max: question.max,
          ),
        );
      case QuestionType.text:
        question = question as QuestionText;
        return CustomField._(
          question.label,
          _TextField(
            key: UniqueKey(),
            hintText: question.hintText,
            maxLength: question.length,
          ),
        );
    }
  }

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
  final String? hintText;
  final int? min;
  final int? max;

  const _NumberField({
    super.key,
    this.onChanged,
    this.hintText,
    this.min,
    this.max,
  });

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

class _CounterField extends StatefulWidget {
  final Function(int)? onChanged;
  final int? min;
  final int? max;
  final int? preset;
  const _CounterField({
    super.key,
    this.onChanged,
    this.min,
    this.max,
    this.preset,
  });

  @override
  State<_CounterField> createState() => _CounterFieldState();
}

class _CounterFieldState extends State<_CounterField> {
  int count = 0;

  @override
  void initState() {
    super.initState();
    count = widget.preset ?? widget.min ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(40),
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

class _TextField extends StatefulWidget {
  final Function(String)? onChanged;
  final String? hintText;
  final int maxLength;

  const _TextField({
    super.key,
    this.onChanged,
    this.hintText = "0",
    this.maxLength = 50,
  });

  @override
  State<_TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<_TextField> {
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
