import 'package:flutter/material.dart';
import 'package:scouting_app/consts.dart';
import 'package:scouting_app/model/match_result.dart';

class MatchResultCard extends StatelessWidget {
  final MatchResult matchResult;

  const MatchResultCard({super.key, required this.matchResult});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      padding: const EdgeInsets.all(kBorderRadius),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              Text("Team ${matchResult.teamNumber}"),
              Text((matchResult.data["dateTime"] as DateTime).toString()),
              Text("Match ${matchResult.matchNumber}"),
            ],
          ),
          const Spacer(),
          IconButton(onPressed: () {}, icon: Icon(Icons.qr_code_2)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
    );
  }
}
