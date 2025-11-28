import 'package:flutter/material.dart';
import 'package:scouting_app/consts.dart';

class FormSection extends StatelessWidget {
  final String title;

  final List<Widget> children;

  const FormSection({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(kBorderRadius)),
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          ...children,
        ],
      ),
    );
  }
}
