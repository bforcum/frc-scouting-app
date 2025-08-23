enum QuestionType {
  toggle(type: bool),
  counter(type: int),
  number(type: int),
  dropdown(type: int),
  text(type: String);

  const QuestionType({required this.type});

  final Type type;
}

abstract class Question {
  final QuestionType type;

  final String key;

  final int section;

  final String label;

  final Function(int)? pointVal;

  const Question._({
    required this.type,
    required this.section,
    required this.key,
    required this.label,
    this.pointVal,
  });
}

class QuestionToggle extends Question {
  final bool? preset;

  @override
  const QuestionToggle({
    required super.section,
    required super.key,
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
    required super.key,
    required super.label,
    super.pointVal,
    required this.min,
    required this.max,
    this.preset,
  }) : assert(max - min < 256, "Counter range must be less than 256"),
       super._(type: QuestionType.counter);
}

class QuestionNumber extends Question {
  final int? min;
  final int? max;
  final String? hint;

  @override
  const QuestionNumber({
    required super.section,
    required super.key,
    required super.label,
    super.pointVal,
    this.min = 0,
    this.max = 65535,
    this.hint,
  }) : assert(
         (min ?? 0) >= 0 && (max ?? 65535) < 65536,
         "Min and max must be in 16-bit int range",
       ),
       assert((min ?? 0) <= (max ?? 65535), "Min can't be greater than max"),
       super._(type: QuestionType.number);
}

class QuestionDropdown extends Question {
  final List<String> options;
  final int? preset;

  @override
  const QuestionDropdown({
    required super.section,
    required super.key,
    required super.label,
    super.pointVal,
    required this.options,
    this.preset,
  }) : super._(type: QuestionType.dropdown);
}

class QuestionText extends Question {
  final int length;
  final String? hint;
  final bool requiredField;
  final bool multiline;
  @override
  const QuestionText({
    required super.section,
    required super.key,
    required super.label,
    super.pointVal,
    required this.length,
    this.requiredField = false,
    this.multiline = false,
    this.hint,
  }) : super._(type: QuestionType.text);
}
