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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            _weekRangeText(days.first, days.last),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        // Grid: Time column + Scrollable Day columns
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Time Column
                _buildTimeColumn(),

                // Scrollable horizontal day columns
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: days.map((day) {
                        final dayEvents = events.where((e) =>
                        e.start.year == day.year &&
                            e.start.month == day.month &&
                            e.start.day == day.day).toList();

                        return SizedBox(
                          width: 200,
                          child: DayView(
                            date: day,
                            events: dayEvents,
                            showTimeLabels: false,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeColumn() {
    final hours = List.generate(24, (index) => index);
    return SizedBox(
      width: 60,
      child: Column(
        children: hours.map((hour) {
          return SizedBox(
            height: 60,
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                '${hour.toString().padLeft(2, '0')}:00',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _weekRangeText(DateTime start, DateTime end) {
    format(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
    return 'Week: ${format(start)} - ${format(end)}';
  }
}
