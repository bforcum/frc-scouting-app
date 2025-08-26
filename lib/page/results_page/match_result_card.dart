import 'package:flutter/material.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/match_result.dart';
import 'package:scouting_app/page/results_page/qr_code_overlay.dart';

class MatchResultCard extends StatelessWidget {
  final MatchResult matchResult;

  const MatchResultCard({super.key, required this.matchResult});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      padding: const EdgeInsets.all(kBorderRadius),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Team ${matchResult.teamNumber}",
                style: TextStyle(fontSize: 20),
              ),
              Text.rich(
                TextSpan(
                  text: "Match ${matchResult.matchNumber}",
                  children: [
                    TextSpan(
                      text:
                          " - ${(matchResult.data["dateTime"] as DateTime).copyWith(second: 0, millisecond: 0).toLocal().toString().substring(0, 16)}",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () => showQRCodeOverlay(matchResult.toBin()),
            icon: Icon(Icons.qr_code),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
    );
  }
}
