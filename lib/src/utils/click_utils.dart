import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/data/data.dart';

/// The class helper for click event
class ClickUtils extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final Color? color;
  final bool enable;

  const ClickUtils({
    super.key,
    required this.onTap,
    required this.child,
    this.enable = true,
    this.color,
    this.padding = const EdgeInsets.all(0),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: enable ? onTap : null,
        splashColor: color != null ? color?.withAlpha(50) : DataApp.splashColor,
        borderRadius: borderRadius,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
