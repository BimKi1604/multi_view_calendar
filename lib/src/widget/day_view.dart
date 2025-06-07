import 'dart:async';
import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/models/calendar_event.dart';
import 'package:multi_view_calendar/src/data/data.dart';
import 'package:multi_view_calendar/src/models/position_event.dart';
import 'package:multi_view_calendar/src/utils/show_utils.dart';
import 'package:multi_view_calendar/src/utils/time_utils.dart';
import 'package:multi_view_calendar/src/widget/day_view_event_tile.dart';

class DayView extends StatefulWidget {
  final DateTime date;
  final List<CalendarEvent> events;
  final bool showTimeLabels;
  final bool onlyDay;

  const DayView({
    super.key,
    required this.date,
    required this.events,
    this.showTimeLabels = true,
    this.onlyDay = true,
  });

  @override
  State<DayView> createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {
  late final Timer _timer;

  @override
  void initState() {
    if (widget.onlyDay) {
      _timer = Timer.periodic(const Duration(minutes: 1), (_) {
        if (mounted) setState(() {});
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.onlyDay) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<CalendarEvent> eventsFilter = TimeUtils.getEventDay(
      day: widget.date,
      totalEvents: widget.events,
    );
    final List<PositionedEvent> positionedEvents = _calculateEventPositions(eventsFilter);
    final Size screenSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Stack(
        children: [
          Visibility(
            visible: widget.onlyDay,
            child: Positioned(
              top: TimeUtils.currentTimeTop - 3,
              left: DataApp.widthTimeColumn - 11,
              right: 0,
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: DataApp.iconColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1.5,
                      color: DataApp.iconColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              /// Left Time Column
              Visibility(
                  visible: widget.onlyDay,
                  child: ShowUtils.buildTimeColumn()),
  
              /// Scrollable horizontal day columns
              Expanded(
                child: SizedBox(
                  width: screenSize.width,
                  child: Stack(
                    children: [
                      if (widget.showTimeLabels) _buildTimeLines(),
                      ...positionedEvents.map((e) => DayViewEventTile(positionedEvent: e)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeLines() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
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
      ),
    );
  }

  List<PositionedEvent> _calculateEventPositions(List<CalendarEvent> events) {
    final List<PositionedEvent> positioned = [];
    final double minuteHeight = DataApp.heightEvent / 60;
    final groups = _groupOverlappingEvents(events); /// group events by overlap

    for (final group in groups) { /// group events by overlap
      if (group.isEmpty) continue; /// skip empty groups
      final eventStartEarliest = group.reduce((a, b) => a.start.isBefore(b.start) ? a : b); /// find earliest start
      final eventEndLatest = group.reduce((a, b) => a.end.isAfter(b.end) ? a : b); /// find latest end
      final int startMinutes = eventStartEarliest.start.hour * 60 + eventStartEarliest.start.minute;
      final int endMinutes = (TimeUtils.isPassDay(eventStartEarliest.start, eventEndLatest.end)
          ? (24 + eventEndLatest.end.difference(eventStartEarliest.start).inHours.abs())
          : eventEndLatest.end.hour) * 60 + eventEndLatest.end.minute;
      final double top = startMinutes * minuteHeight;
      final double height = (endMinutes - startMinutes).clamp(15.0, 1440.0) * minuteHeight;
      positioned.add(PositionedEvent(
        events: group,
        top: top,
        height: height,
        left: 0,
        width: DataApp.widthEvent,
      ));
    }
    return positioned;
  }

  List<List<CalendarEvent>> _groupOverlappingEvents(List<CalendarEvent> events) {
    final sorted = List<CalendarEvent>.from(events)..sort((a, b) => a.start.compareTo(b.start));
    final List<List<CalendarEvent>> group = [];

    for (final event in sorted) {
      bool added = false;
      int index = -2;
      for (final groupOverlap in group) {
        index = groupOverlap.indexWhere((e) => _eventsOverlap(e, event));
        if (index != -1) {
          groupOverlap.add(event);
          added = true;
          break;
        }
      }
      if (!added) {
        group.add([event]);
      }
    }

    return group;
  }

  bool _eventsOverlap(CalendarEvent a, CalendarEvent b) { /// check event overlap
    if (!DateUtils.isSameDay(a.start, b.start)) return false;
    return a.start.isBefore(b.end) && b.start.isBefore(a.end);
  }
}
