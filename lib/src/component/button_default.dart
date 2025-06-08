import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/data/data.dart';
import 'package:multi_view_calendar/src/utils/click_utils.dart';

class ButtonDefault extends StatelessWidget {
  const ButtonDefault({super.key, required this.child, required this.onTap, this.padding});

  final Widget child;
  final Function() onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DataApp.mainColor,
        borderRadius: BorderRadius.circular(30.0),
      ),
      alignment: Alignment.center,
      child: ClickUtils(
        onTap: (){
          onTap();
        },
        borderRadius: BorderRadius.circular(30.0),
        child: Padding(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          child: child,
        ),
      ),
    );
  }
}
