enum QuestionType { toggle, counter, number, dropdown, text }

abstract class Question {
  final QuestionType type;

  final int section;

  final String label;

  final Function(int)? pointVal;

  const Question._({
    required this.type,
    required this.section,
    required this.label,
    this.pointVal,
  });
}

class QuestionToggle extends Question {
  final bool? preset;

  @override
  const QuestionToggle({
    required super.section,
    required super.label,
    this.preset,
    super.pointVal,
  }) : super._(type: QuestionType.toggle);
}

class QuestionCounter extends Question {
  final int min;
  final int max;
  final int? preset;
  @override
  const QuestionCounter({
    required super.section,
    required super.label,
    super.pointVal,
    required this.min,
    required this.max,
    this.preset,
  }) : super._(type: QuestionType.counter);
}

class QuestionNumber extends Question {
  final int? min;
  final int? max;
  final String? hint;

  @override
  const QuestionNumber({
    required super.section,
    required super.label,
    super.pointVal,
    this.min,
    this.max,
    this.hint,
  }) : super._(type: QuestionType.number);
}

class QuestionDropdown extends Question {
  final List<String> options;
  final int? preset;

  @override
  const QuestionDropdown({
    required super.section,
    required super.label,
    super.pointVal,
    required this.options,
    this.preset,
  }) : super._(type: QuestionType.dropdown);
}

class QuestionText extends Question {
  final int length;
  final String? hintText;
  @override
  const QuestionText({
    required super.section,
    required super.label,
    super.pointVal,
    required this.length,
    this.hintText,
  }) : super._(type: QuestionType.text);
}
