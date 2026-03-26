part of 'game_format.dart';

const List<String> _sections2026v2 = [
  "Autonomous",
  "Defense Shifts",
  "Scoring Shifts",
  "Additional",
];

const List<Question> _questions2026v2 = [
  QuestionCounter(
    section: 0,
    key: "autoCycleSize",
    label: "Max cycle size",
    stepSize: 5,
  ),
  QuestionCounter(
    section: 0,
    key: "autoCycleFull",
    label: "Cycles: full hopper",
  ),
  QuestionCounter(
    section: 0,
    key: "autoCycleHalf",
    label: "Cycles: half hopper",
  ),
  QuestionCounter(section: 0, key: "autoCycleSmall", label: "Cycles: few fuel"),
  QuestionSelect(
    section: 0,
    key: "autoAccuracy",
    label: "Accuracy (%)",
    options: ["<30", "30-50", "50-70", "70-90", "90+"],
  ),
  QuestionToggle(section: 0, key: "autoClimbAttempt", label: "Climb Attempted"),
  QuestionToggle(section: 0, key: "autoClimb", label: "Climb Success"),
  QuestionToggle(section: 0, key: "autoWin", label: "Won auto"),
  QuestionSelect(
    section: 1,
    key: "defBlock",
    label: "Blocking opponent movement",
    options: ["N/A", "1", "2", "3"],
    preset: 0,
  ),
  QuestionSelect(
    section: 1,
    key: "defPush",
    label: "Pushing opponents trying to score",
    options: ["N/A", "1", "2", "3"],
    preset: 0,
  ),
  QuestionSelect(
    section: 1,
    key: "defPass",
    label: "Passing fuel to alliance zone",
    options: ["N/A", "1", "2", "3"],
    preset: 0,
  ),
  QuestionSelect(
    section: 1,
    key: "defCollect",
    label: "Collecting fuel",
    options: ["N/A", "Some", "Primarily"],
    preset: 0,
  ),
  QuestionSelect(
    section: 1,
    key: "defFuelPush",
    label: "Pushing Fuel",
    options: ["N/A", "Some", "Primarily"],
    preset: 0,
  ),
  QuestionToggle(section: 1, key: "defWasted", label: "Shot at hub (wasted)"),
  QuestionCounter(
    section: 2,
    key: "teleCycleSize",
    label: "Hopper size",
    stepSize: 5,
  ),
  _QuestionCounterGrid(
    section: 2,
    key: "teleHubCycles",
    label: "Hub Cycles (accuracy & amount in hopper)",
    rowLabels: ["Full", "Half", "Few"],
    columnLabels: ["Good", "Okay", "Bad"],
  ),
  QuestionSelect(
    section: 2,
    key: "offensePass",
    label: "Passing",
    options: ["None", "Some", "Lots"],
  ),
  QuestionCounter(
    section: 3,
    key: "climb",
    label: "Climb level",
    min: 0,
    max: 3,
  ),
  QuestionToggle(section: 3, key: "groundPickup", label: "Ground Pickup"),
  QuestionToggle(section: 3, key: "moveShot", label: "Can shoot while moving"),
  QuestionToggle(section: 3, key: "disabled", label: "Disabled during match"),
];

class _QuestionCounterGrid extends Question<List<int>> {
  @override
  final int cellCount = 1;
  @override
  final String key;
  @override
  final int section;
  @override
  final String label;
  @override
  final List<int>? preset;

  final List<String> columnLabels;
  final List<String> rowLabels;

  final int min;
  final int max;

  const _QuestionCounterGrid({
    required this.section,
    required this.key,
    required this.label,
    required this.columnLabels,
    required this.rowLabels,
    this.preset,
    this.min = 0,
    this.max = 255,
  }) : assert(max - min < 256);
  @override
  Widget input({required context, value, required onChanged, errorText}) {
    List<List<Widget>> cells = [];
    for (int i = 0; i < rowLabels.length; i++) {
      cells.add(<Widget>[]);
      for (int j = 0; j < columnLabels.length; j++) {
        cells[i].add(
          DenseCounterInput(
            value: (value ?? preset)?[3 * i + j] ?? 0,
            onChanged: (val) {
              List<int> newList =
                  value?.copy() ??
                  List.filled(columnLabels.length * rowLabels.length, 0);
              newList[3 * i + j] = val;
              onChanged(newList);
            },
          ),
        );
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 40),
            ...columnLabels.map(
              (columnLabel) => Container(
                margin: EdgeInsets.symmetric(horizontal: 6),
                width: 68,
                height: 60,
                alignment: Alignment.center,
                child: Text(columnLabel),
              ),
            ),
          ],
        ),
        ...rowLabels.mapIndexed(
          (i, rowLabel) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 60,
                alignment: Alignment.center,
                child: Text(rowLabel),
              ),
              ...cells[i],
            ],
          ),
        ),
      ],
    );
  }

  @override
  String? validator(value, onChanged) {
    onChanged(
      value ?? List.generate(rowLabels.length * columnLabels.length, (i) => 0),
    );
    return null;
  }

  @override
  Widget view(BuildContext context, val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextTheme.of(context).bodyMedium),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 40),
            ...columnLabels.map(
              (columnLabel) => Container(
                width: 68,
                height: 60,
                alignment: Alignment.center,
                child: Text(columnLabel),
              ),
            ),
          ],
        ),
        ...rowLabels.mapIndexed(
          (i, rowLabel) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 60,
                alignment: Alignment.center,
                child: Text(rowLabel),
              ),
              for (int j = 0; j < columnLabels.length; j++)
                Container(
                  width: 68,
                  height: 60,
                  alignment: Alignment.center,
                  child: Text(
                    val[3 * i + j].toString(),
                    style: TextTheme.of(context).bodyLarge,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void toBin(writer, val) => writer.write(val.mapToList((a) => a - min));
  @override
  List<int>? fromBin(reader) =>
      reader.read(columnLabels.length * rowLabels.length).toList();
  @override
  List<CellValue> toExcel(value) => value.mapToList((a) => IntCellValue(a));
  @override
  List<int> fromExcel(cells, i) {
    List<int> values = [];
    for (int j = 0; j < columnLabels.length * rowLabels.length; j++) {
      values.add((cells[i + j].value! as IntCellValue).value);
    }
    return values;
  }

  @override
  List<int> randomValue([generator]) {
    List<int> values = [];
    for (int i = 0; i < columnLabels.length * rowLabels.length; i++) {
      values.add(
        (generator ?? math.Random()).nextInt(math.min(max, 20) - min) + min,
      );
    }
    return values;
  }
}
