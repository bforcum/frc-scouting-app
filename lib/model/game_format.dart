import 'package:scouting_app/model/question.dart';

class GameFormat {
  final String name;

  final List<String> sections;

  final List<Question> questions;

  GameFormat({
    required this.name,
    required this.sections,
    required this.questions,
  });
}
