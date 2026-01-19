abstract interface class MatchAnalysis {
  static late List<String> scoreOptions;

  int getScore(int scoreOption);

  static late List<String> criteriaOptions;

  bool getCriterion(int criterion);
}
