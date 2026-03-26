import 'dart:convert' show utf8;
import 'dart:math';
import 'dart:typed_data';

import 'package:buffer/buffer.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:scouting_app/page/results_page/result_field.dart';
import 'package:scouting_app/page/scouting_page/form_input/counter_input.dart';
import 'package:scouting_app/page/scouting_page/form_input/number_input.dart';
import 'package:scouting_app/page/scouting_page/form_input/select_input.dart';
import 'package:scouting_app/page/scouting_page/form_input/text_input.dart';
import 'package:scouting_app/page/scouting_page/form_input/toggle_input.dart';

enum QuestionType {
  toggle(type: bool),
  counter(type: int),
  number(type: int),
  select(type: int),
  text(type: String);

  const QuestionType({required this.type});

  final Type type;
}

abstract class Question<T> {
  abstract final QuestionType type;
  abstract final String key;
  abstract final int section;
  abstract final String label;
  abstract final T? preset;
  abstract final int cellCount;

  Widget input({
    T? value,
    required void Function(T? value) onChanged,
    String? errorText,
  });
  String? validator(T? value, void Function(T?) onChanged);
  Widget view(T value);
  void toBin(ByteDataWriter writer, T val);
  T? fromBin(ByteDataReader reader);
  List<CellValue> toExcel(T val);
  T fromExcel(List<Data> cells, int i);
  T randomValue([Random? generator]);

  const Question();
}

class QuestionToggle extends Question<bool> {
  @override
  final QuestionType type = QuestionType.toggle;
  @override
  final int cellCount = 1;
  @override
  final String key;
  @override
  final int section;
  @override
  final String label;
  @override
  final bool preset;

  const QuestionToggle({
    required this.section,
    required this.key,
    required this.label,
    this.preset = false,
  });

  @override
  Widget input({
    bool? value,
    required void Function(bool?) onChanged,
    String? errorText,
  }) {
    return ToggleQuestionInput(
      label: label,
      preset: preset,
      value: value,
      onChanged: onChanged,
    );
  }

  @override
  String? validator(value, onChanged) {
    onChanged(value ?? preset);
    return null;
  }

  @override
  Widget view(value) => MatchResultField(label: label, value: value.toString());
  @override
  void toBin(writer, val) => writer.writeUint8(val == true ? 1 : 0);
  @override
  bool fromBin(reader) => reader.readUint8() > 0 ? true : false;
  @override
  List<CellValue> toExcel(value) => [BoolCellValue(value)];
  @override
  bool fromExcel(cells, i) => (cells[i].value as BoolCellValue).value;
  @override
  bool randomValue([generator]) => generator?.nextBool() ?? Random().nextBool();
}

class QuestionCounter extends Question<int> {
  @override
  final QuestionType type = QuestionType.counter;
  @override
  final int cellCount = 1;
  @override
  final String key;
  @override
  final int section;
  @override
  final String label;
  @override
  final int? preset;

  final int min;
  final int max;
  final int stepSize;

  const QuestionCounter({
    required this.section,
    required this.key,
    required this.label,
    this.preset,
    this.min = 0,
    this.max = 255,
    this.stepSize = 1,
  }) : assert(max - min < 256, "Counter range must be less than 256"),
       assert(stepSize > 0);
  @override
  Widget input({int? value, required onChanged, errorText}) =>
      CounterQuestionInput(
        label: label,
        value: value ?? preset ?? min,
        min: min,
        max: max,
        stepSize: stepSize,
        onChanged: onChanged,
      );
  @override
  String? validator(value, onChanged) {
    onChanged(value ?? preset ?? min);
    return null;
  }

  @override
  Widget view(val) => MatchResultField(label: label, value: val.toString());
  @override
  void toBin(writer, val) => writer.writeUint8(val - min);
  @override
  int fromBin(reader) => reader.readUint8() + min;
  @override
  List<CellValue> toExcel(value) => [IntCellValue(value)];
  @override
  int fromExcel(cells, i) => (cells[i].value as IntCellValue).value;
  @override
  int randomValue([generator]) =>
      (generator ?? Random()).nextInt(max - min) + min;
}

class QuestionNumber extends Question<int> {
  @override
  final QuestionType type = QuestionType.number;
  @override
  final int cellCount = 1;
  @override
  final String key;
  @override
  final int section;
  @override
  final String label;
  @override
  final int? preset;
  final int min;
  final int max;
  final String? hint;

  @override
  const QuestionNumber({
    required this.section,
    required this.key,
    required this.label,
    this.min = 0,
    this.max = 65535,
    this.preset,
    this.hint,
  }) : assert(
         min >= 0 && max < 65536,
         "Min and max must be in 16-bit int range",
       ),
       assert(min <= max, "Min can't be greater than max");
  @override
  Widget input({value, required onChanged, errorText}) => NumberQuestionInput(
    label: label,
    initialValue: value,
    min: min,
    max: max,
    hint: hint,
    errorText: errorText,
    onChanged: onChanged,
  );
  @override
  String? validator(value, onChanged) {
    if (value == null) {
      return 'Please answer the question';
    }

    if ((value < min) || (value > max)) {
      return 'Value must be between $min and $max';
    }
    return null;
  }

  @override
  Widget view(val) => MatchResultField(label: label, value: val.toString());
  @override
  void toBin(writer, val) => writer.writeUint16(val - min);
  @override
  int fromBin(reader) => reader.readUint16() + min;
  @override
  List<CellValue> toExcel(value) => [IntCellValue(value)];
  @override
  int fromExcel(cells, i) => (cells[i].value as IntCellValue).value;
  @override
  int randomValue([generator]) =>
      (generator ?? Random()).nextInt(max - min) + min;
}

class QuestionSelect extends Question<int> {
  @override
  final QuestionType type = QuestionType.select;
  @override
  final int cellCount = 1;
  @override
  final String key;
  @override
  final int section;
  @override
  final String label;
  @override
  final int? preset;

  final List<String> options;
  final bool dropdown;

  @override
  const QuestionSelect({
    required this.section,
    required this.key,
    required this.label,
    required this.options,
    this.preset,
    this.dropdown = false,
  }) : assert(preset == null || (0 <= preset && preset < options.length));

  @override
  Widget input({value, required onChanged, errorText}) => SelectQuestionInput(
    label: label,
    options: options,
    dropdown: dropdown,
    errorText: errorText,
    initialValue: value ?? preset,
    onChanged: onChanged,
  );
  @override
  String? validator(value, onChanged) {
    if (value == null) {
      if (preset == null) {
        return 'Please select an option';
      } else {
        onChanged(preset);
      }
    }
    return null;
  }

  @override
  Widget view(val) => MatchResultField(label: label, value: options[val]);
  @override
  void toBin(writer, val) => writer.writeInt8(val);
  @override
  int fromBin(reader) => reader.readInt8();
  @override
  List<CellValue> toExcel(val) => [TextCellValue(options[val])];
  @override
  int fromExcel(cells, i) =>
      options.indexOf((cells[i].value as TextCellValue).value.text!);
  @override
  int randomValue([generator]) =>
      (generator ?? Random()).nextInt(options.length);
}

class QuestionText extends Question<String> {
  @override
  final QuestionType type = QuestionType.text;
  @override
  final int cellCount = 1;
  @override
  final String key;
  @override
  final int section;
  @override
  final String label;
  @override
  final String? preset;

  final int length;
  final String? hint;
  final bool requiredField;
  final bool big;

  const QuestionText({
    required this.section,
    required this.key,
    required this.label,
    required this.length,
    this.requiredField = false,
    this.big = true,
    this.hint,
  }) : preset = null;
  @override
  Widget input({value, required onChanged, errorText}) => TextQuestionInput(
    label: label,
    length: length,
    hint: hint,
    errorText: errorText,
    initialValue: value,
    onChanged: onChanged,
  );
  @override
  String? validator(value, onChanged) {
    if ((value == null || value == "") && requiredField) {
      return 'Please respond to the question';
    }
    // Set value to empty string if this is not a required field
    if (value == null && !requiredField) {
      onChanged("");
    }
    return null;
  }

  @override
  Widget view(val) => MatchResultField(
    label: label,
    value: val.toString(),
    hint: "No data",
    big: big,
  );
  @override
  void toBin(writer, val) {
    Uint8List text = utf8.encode(val.toString());
    writer.writeUint8(text.length);
    writer.write(text);
  }

  @override
  String fromBin(reader) {
    int length = reader.readUint8();
    return String.fromCharCodes(reader.read(length)).trim();
  }

  @override
  List<CellValue> toExcel(val) => [TextCellValue(val)];
  @override
  String fromExcel(cells, i) =>
      (cells[i].value as TextCellValue).value.text ?? "";
  @override
  String randomValue([generator]) => "Sample Text";
}
