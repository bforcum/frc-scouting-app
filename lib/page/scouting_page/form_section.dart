import 'package:flutter/material.dart';
import 'package:scouting_app/consts.dart';

class FormSection extends StatelessWidget {
  final String? title;

  final List<Widget> children;

  const FormSection({super.key, this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(kBorderRadius)),
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: List.from(
            title != null
                ? [
                  Text(
                    title!,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ]
                : [],
          )..addAll(children),
        ),
      ),
    );
  }
}
