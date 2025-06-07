import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/utils/click_utils.dart';
import 'package:multi_view_calendar/src/utils/time_utils.dart';

class MonthHeader extends StatelessWidget {
  const MonthHeader({super.key, required this.month});

  final DateTime month;

  @override
  Widget build(BuildContext context) {
    return ClickUtils(
      onTap: (){

      },
      color: Colors.grey[400],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Flexible(
              child: Text(
                TimeUtils.formatMonthYear(month),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Icon(Icons.arrow_drop_down, size: 23, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
