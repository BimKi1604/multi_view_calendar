import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/data/data.dart';
import 'package:multi_view_calendar/src/utils/show_utils.dart';
import 'package:multi_view_calendar/src/utils/time_utils.dart';

class WeekRowItem extends StatelessWidget {
  const WeekRowItem({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: DataApp.heightEvent,
      width: DataApp.widthEvent,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: const Border(
            right: BorderSide(
                width: 1,
                color: Colors.white
            )
        ),
        color: DataApp.mainColor,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 7.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${TimeUtils.weekdayLabel(date.weekday)}\n${date.day}/${date.month}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(width: 7.0),
              Visibility(
                  visible: TimeUtils.isToday(date),
                  child: ShowUtils.eventWidget(
                      child: Icon(Icons.today, color: DataApp.iconColor, size: 11,)
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
