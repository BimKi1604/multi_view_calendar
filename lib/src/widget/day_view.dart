import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/models/calendar_event.dart';
import 'package:multi_view_calendar/src/data/data.dart';
import 'package:multi_view_calendar/src/models/position_event.dart';
import 'package:multi_view_calendar/src/widget/day_view_event_tile.dart';

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
    final List<PositionedEvent> positionedEvents = _calculateEventPositions(events);

    return Stack(
      children: [
        if (showTimeLabels) _buildTimeLines(),
        ...positionedEvents.map((e) => DayViewEventTile(positionedEvent: e)),
      ],
    );
  }

  Widget _buildTimeLines() {
    return Column(
      children: List.generate(24, (index) {
        return Container(
          height: DataApp.heightEvent,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade300, width: 0.5),
            ),
          ),
        );
      }),
    );
  }

  List<PositionedEvent> _calculateEventPositions(List<CalendarEvent> events) {
    final List<PositionedEvent> positioned = [];
    final double minuteHeight = DataApp.heightEvent / 60;
    final List<List<CalendarEvent>> groups = _groupOverlappingEvents(events);

    if (groups.isEmpty) return [];

    final group = groups.first;
    for (int i = 0; i < group.length; i++) {
      final event = group[i];
      final int startMinutes = event.start.hour * 60 + event.start.minute;
      final int endMinutes = event.end.hour * 60 + event.end.minute;
      final double top = startMinutes * minuteHeight;
      final double height = (endMinutes - startMinutes).clamp(15.0, 1440.0) * minuteHeight;
      final double width = DataApp.widthEvent / group.length;
      final double left = i * width;

      positioned.add(PositionedEvent(
        event: event,
        top: top,
        height: height,
        left: left,
        width: width,
      ));
    }

    return positioned;
  }

  List<List<CalendarEvent>> _groupOverlappingEvents(List<CalendarEvent> events) {
    final sorted = List<CalendarEvent>.from(events)..sort((a, b) => a.start.compareTo(b.start));
    final List<List<CalendarEvent>> groups = [];

    for (final event in sorted) {
      bool added = false;
      for (final group in groups) {
        if (!group.any((e) => _eventsOverlap(e, event))) {
          group.add(event);
          added = true;
          break;
        }
      }
      if (!added) {
        groups.add([event]);
      }
    }

    return groups;
  }

  bool _eventsOverlap(CalendarEvent a, CalendarEvent b) { /// check event overlap
    return a.start.isBefore(b.end) && b.start.isBefore(a.end);
  }
}
