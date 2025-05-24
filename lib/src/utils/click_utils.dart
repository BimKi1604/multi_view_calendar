import 'package:flutter/material.dart';

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
    this.padding = const EdgeInsets.all(4),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: enable ? onTap : null,
        splashColor: color?.withAlpha(50),
        borderRadius: borderRadius,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
