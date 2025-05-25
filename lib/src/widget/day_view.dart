import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/data/data.dart';
import 'package:multi_view_calendar/src/models/calendar_event.dart';
import 'package:multi_view_calendar/src/utils/date_utils.dart';

class DayView extends StatelessWidget {
  final DateTime date;
  final List<CalendarEvent> events;
  final bool showTimeLabels;

  const DayView({
    super.key,
    required this.date,
    required this.events,
    this.showTimeLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    final hours = List.generate(24, (hour) => hour);
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey[200],
            child: Center(
              child: Text(
                '${weekdayLabel(date.weekday)}\n${date.day}/${date.month}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Time slots
          Column(
            children: hours.map((data) {
              final hourEvents = events.where((event) => event.start.hour == data).toList();
              return Container(
                height: DataApp.heightEvent,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                ),
                padding: const EdgeInsets.all(4),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: hourEvents.map((event) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 2),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          event.title,
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
