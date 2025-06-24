import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_view_calendar/src/data/data.dart';

class LazyWeekElement extends StatelessWidget {
  const LazyWeekElement({super.key, required this.weekStart, required this.setSelected, required this.selectedDate});

  final DateTime weekStart;
  final Function(DateTime) setSelected;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(7, (i) {
        final day = weekStart.add(Duration(days: i));
        final isSelected = DateUtils.isSameDay(day, selectedDate);

        return GestureDetector(
          onTap: () {
            setSelected(day);
          },
          child: Container(
            width: 56,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: isSelected ? DataApp.mainColor : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: DataApp.mainColor.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day.day.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  DateFormat.E().format(day).toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    color: isSelected ? Colors.white : Colors.grey,
                  ),
                ),
                if (isSelected)
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(Icons.circle, size: 4, color: Colors.white),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
