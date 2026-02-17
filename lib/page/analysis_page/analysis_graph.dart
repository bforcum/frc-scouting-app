import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scouting_app/model/team_data.dart';

class AnalysisGraph extends StatelessWidget {
  const AnalysisGraph({
    super.key,
    required this.stats,
    required this.criterion,
  });

  final List<TeamData> stats;
  final int criterion;

  @override
  Widget build(BuildContext context) {
    final double max = stats[0].scores[criterion].average;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: ColorScheme.of(context).surfaceContainer,
      ),
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SizedBox(width: 60, child: Text("Team")),
                  Expanded(child: Text("Score", textAlign: TextAlign.center)),
                ],
              ),
              ...stats.map((e) {
                double score = e.scores[criterion].average;
                double fraction = score / max;
                return Row(
                  spacing: 10,
                  children: [
                    SizedBox(
                      width: 50,
                      child: Text(
                        e.teamNumber.toString(),
                        style: GoogleFonts.robotoMono(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Container(
                      alignment: AlignmentGeometry.centerRight,
                      height: 30,
                      width: (constraints.maxWidth - 60.0) * fraction,
                      color:
                          Theme.of(context).brightness == Brightness.light
                              ? Colors.blue.shade300
                              : Colors.blue.shade700,
                      child:
                          (fraction > 0.5)
                              ? Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  score.round().toString(),
                                  style: GoogleFonts.robotoMono(),
                                ),
                              )
                              : null,
                    ),
                    if (fraction < 0.5)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          score.round().toString(),
                          style: GoogleFonts.robotoMono(),
                        ),
                      ),
                  ],
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
