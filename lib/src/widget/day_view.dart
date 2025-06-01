import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/models/calendar_event.dart';
import 'package:multi_view_calendar/src/data/data.dart';
import 'package:multi_view_calendar/src/models/position_event.dart';
import 'package:multi_view_calendar/src/utils/time_utils.dart';
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
    final double minuteHeight = DataApp.heightEvent / 60; /// height pixel each minute
    final List<List<CalendarEvent>> groups = _groupOverlappingEvents(events);

    if (groups.isEmpty) return positioned;
    if (groups.length == 1) {
      final group = groups.first;
      for (int i = 0; i < group.length; i++) {
        final event = group[i];
        final int startMinutes = event.start.hour * 60 + event.start.minute;
        final int endMinutes = (TimeUtils.isPassDay(event.start, event.end) ? (24 + event.end.difference(event.start).inHours.abs()) : event.end.hour) * 60 + event.end.minute;
        final double top = startMinutes * minuteHeight;
        final double height = (endMinutes - startMinutes).clamp(15.0, 1440.0) * minuteHeight;

        positioned.add(PositionedEvent(
          events: [event],
          top: top,
          height: height,
          left: 0,
          width: DataApp.widthEvent,
        ));
        /// case pass day
        // if (event.start.day < event.end.day) {
        //   final DateTime end = event.end;
        //   final int overMinutes = end.difference(DateTime(end.year,end.month, end.day, 0, 0)).inMinutes.abs();
        //   final int minutes = overMinutes % 60;
        //   final int hours = overMinutes ~/ 60;
        //   const int startMinutes = 0;
        //   final int endMinutes = hours * 60 + minutes;
        //   const double top = 0;
        //   final double height = (endMinutes - startMinutes).clamp(15.0, 1440.0) * minuteHeight;
        //   /// Thêm case nếu add mới vào trùng lịch đã có thì phải group lại
        //   /// Case pass qua ngày thì thời gian over ngày mới đã hiển thị nhưng vẫn đang nằm ở ngày cũ
        //   positioned.add(PositionedEvent(
        //     events: [event],
        //     top: top,
        //     height: height,
        //     left: 0,
        //     width: DataApp.widthEvent,
        //   ));
        // }
      }
      return positioned;
    }
    List<CalendarEvent> eventsList = List.empty(growable: true);

    for (final group in groups) {
      for (int i = 0; i < group.length; i++) {
        final event = group[i];
        final int startMinutes = event.start.hour * 60 + event.start.minute;
        final int endMinutes = (TimeUtils.isPassDay(event.start, event.end) ? (24 + event.end.difference(event.start).inHours.abs()) : event.end.hour) * 60 + event.end.minute;
        final double top = startMinutes * minuteHeight;
        final double height = (endMinutes - startMinutes).clamp(15.0, 1440.0) * minuteHeight;

        eventsList.add(group[i]);

        positioned.add(PositionedEvent(
          events: eventsList,
          top: top,
          height: height,
          left: 0,
          width: DataApp.widthEvent,
        ));
        /// case pass day
        // if (event.start.day < event.end.day) {
        //   final DateTime end = event.end;
        //   final int overMinutes = end.difference(DateTime(end.year,end.month, end.day, 0, 0)).inMinutes.abs();
        //   final int minutes = overMinutes % 60;
        //   final int hours = overMinutes ~/ 60;
        //   const int startMinutes = 0;
        //   final int endMinutes = hours * 60 + minutes;
        //   const double top = 0;
        //   final double height = (endMinutes - startMinutes).clamp(15.0, 1440.0) * minuteHeight;
        //   positioned.add(PositionedEvent(
        //     events: [event],
        //     top: top,
        //     height: height,
        //     left: 0,
        //     width: DataApp.widthEvent,
        //   ));
        // }
      }
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
    if (!DateUtils.isSameDay(a.start, b.start)) return false;
    return a.start.isBefore(b.end) && b.start.isBefore(a.end);
  }
}
