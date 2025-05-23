import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/data/calendar_event.dart';

class DayView extends StatelessWidget {
  final DateTime date;
  final List<CalendarEvent> events;

  const DayView({
    super.key,
    required this.date,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final dayEvents = events
        .where((e) =>
    e.start.day == date.day &&
        e.start.month == date.month &&
        e.start.year == date.year)
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));

    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          dayEvents.isEmpty
              ? const Center(child: Text("No events"))
              : SizedBox(
            height: MediaQuery.sizeOf(context).height * .1,
                child: ListView.builder(
                            itemCount: dayEvents.length,
                            itemBuilder: (context, index) {
                final event = dayEvents[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(event.title),
                    subtitle: Text(
                      '${_formatTime(event.start)} - ${_formatTime(event.end)}',
                    ),
                    trailing: event.color != null
                        ? CircleAvatar(
                      radius: 6,
                      backgroundColor: Color(event.color ?? 0xFF000000),
                    )
                        : null,
                  ),
                );
                            },
                          ),
              ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
