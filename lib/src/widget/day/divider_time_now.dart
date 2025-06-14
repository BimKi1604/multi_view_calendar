import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/data/data.dart';
import 'package:multi_view_calendar/src/utils/time_utils.dart';

class DividerTimeNow extends StatelessWidget {
  const DividerTimeNow({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: TimeUtils.currentTimeTop - 3,
      left: DataApp.widthTimeColumn - 11,
      right: 0,
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: DataApp.iconColor,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Container(
              height: 1.5,
              color: DataApp.iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
