import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/data/data.dart';
import 'package:multi_view_calendar/src/utils/time_utils.dart';

class WeekdayHeader extends StatelessWidget {
  const WeekdayHeader({super.key});

  @override
  Widget build(BuildContext context) {
    const weekdays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    DateTime today = DateTime.now();
    String todayShortWeekday = TimeUtils.dateTimeToShortWeekday(today);

    return Row(
      children: weekdays
          .map(
            (day) => Expanded(
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: todayShortWeekday == day ? DataApp.mainColor : Colors.grey.shade300, width: todayShortWeekday == day ? 2 : 1),
              ),
            ),
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              day,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: todayShortWeekday == day ? DataApp.mainColor : Colors.grey),
            ),
          ),
        ),
      )
          .toList(),
    );
  }
}
