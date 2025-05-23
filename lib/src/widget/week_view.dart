import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/data/calendar_event.dart';
import 'package:multi_view_calendar/src/widget/day_view.dart';

class WeekView extends StatelessWidget {
  final DateTime weekStartDate;
  final List<CalendarEvent> events;

  const WeekView({
    super.key,
    required this.weekStartDate,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final days = List.generate(
      7,
          (index) => weekStartDate.add(Duration(days: index)),
    );

    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              _weekRangeText(days.first, days.last),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: DayView(
                    date: day,
                    events: events,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _weekRangeText(DateTime start, DateTime end) {
    format(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
    return 'Week: ${format(start)} - ${format(end)}';
  }
}
