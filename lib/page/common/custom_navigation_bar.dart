import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final List<IconData> destinationIcons;
  final List<String> destinationLabels;
  final int selectedIndex;
  final void Function(int) onDestinationSelected;

  final Color? backgroundColor;
  final Color? iconColor;
  final Color? selectedColor;

  const CustomNavigationBar({
    super.key,
    required this.destinationIcons,
    required this.destinationLabels,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.backgroundColor,
    this.iconColor,
    this.selectedColor,
  }) : assert(destinationIcons.length == destinationLabels.length),
       assert(0 <= selectedIndex && selectedIndex <= destinationIcons.length);

  @override
  Widget build(BuildContext context) {
    Color baseColor =
        backgroundColor ?? ColorScheme.of(context).surfaceContainerHigh;
    Color onBaseColor = iconColor ?? ColorScheme.of(context).onSurface;
    Color indicatorColor =
        selectedColor ?? ColorScheme.of(context).primaryFixedDim;
    List<Widget> buttons = [];
    for (int i = 0; i < destinationIcons.length; i++) {
      buttons.add(
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onDestinationSelected(i),
            child: Container(
              color: baseColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 4,
                children: [
                  Icon(
                    destinationIcons[i],
                    color: i == selectedIndex ? indicatorColor : onBaseColor,
                  ),
                  Text(
                    destinationLabels[i],
                    style: TextTheme.of(context).bodySmall!.copyWith(
                      fontWeight: i == selectedIndex ? FontWeight.w700 : null,
                      color: i == selectedIndex ? indicatorColor : onBaseColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      color: baseColor,
      child: SafeArea(
        child: SizedBox(
          height: 80,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: buttons,
          ),
        ),
      ),
    );
  }
}
