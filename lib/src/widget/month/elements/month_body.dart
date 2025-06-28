import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/data/data.dart';
import 'package:multi_view_calendar/src/models/calendar_event.dart';
import 'package:multi_view_calendar/src/utils/click_utils.dart';

class MonthBody extends StatelessWidget {
  const MonthBody(
      {super.key,
      required this.days,
      required this.events,
      required this.onDaySelected,
      required this.dayDecoration,
      required this.getEventColor});

  final List<DateTime> days;
  final List<CalendarEvent> events;
  final Function(DateTime) onDaySelected;
  final Decoration? Function(DateTime) dayDecoration;
  final Color? Function(DateTime) getEventColor;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: days.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1.25,
        ),
        itemBuilder: (context, index) {
          final day = days[index];
          final dayEvents =
              events.where((e) => DateUtils.isSameDay(e.start, day)).toList();

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 3.0),
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            decoration: dayDecoration(day),
            child: ClickUtils(
              onTap: () {
                onDaySelected(day);
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: getEventColor(day),
                      ),
                    ),
                  ),
                  if (dayEvents.isNotEmpty)
                    Flexible(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 6.5),
                        itemCount: dayEvents.length > 2 ? 2 : dayEvents.length,
                        itemBuilder: (context, idx) {
                          final event = dayEvents[idx];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 1),
                            decoration: BoxDecoration(
                              color: event.color != null
                                  ? event.color!.withOpacity(0.8)
                                  : DataApp.mainColor.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              event.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.white),
                            ),
                          );
                        },
                      ),
                    )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
