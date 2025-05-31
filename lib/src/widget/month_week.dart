import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/models/calendar_event.dart';
import 'package:multi_view_calendar/src/utils/time_utils.dart';
// import 'package:multi_view_calendar/src/utils/time_utils.dart';

class MonthView extends StatelessWidget {
  final DateTime month;
  final List<CalendarEvent> events;

  const MonthView({
    super.key,
    required this.month,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = TimeUtils.startOfMonth(month);
    final days = TimeUtils.daysInMonthGrid(firstDayOfMonth);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            '${month.year} - ${month.month.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        _buildWeekdayHeader(),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: days.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              final day = days[index];
              final dayEvents = events.where((e) =>
              e.start.year == day.year &&
                  e.start.month == day.month &&
                  e.start.day == day.day).toList();

              final isOutsideMonth = day.month != month.month;

              return Container(
                decoration: BoxDecoration(
                  color: isOutsideMonth ? Colors.grey.shade200 : Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isOutsideMonth ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
                    if (dayEvents.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: dayEvents.length > 2 ? 2 : dayEvents.length,
                          itemBuilder: (context, idx) {
                            final event = dayEvents[idx];
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                color: event.color != null
                                    ? event.color!.withOpacity(0.8)
                                    : Colors.blue.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                event.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 10, color: Colors.white),
                              ),
                            );
                          },
                        ),
                      )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeekdayHeader() {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Row(
      children: weekdays
          .map(
            (day) => Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                day,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      )
          .toList(),
    );
  }
}
