import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/models/calendar_event.dart';
import 'package:multi_view_calendar/src/models/position_event.dart';
import 'package:multi_view_calendar/src/utils/show_utils.dart';

class DayViewEventTile extends StatelessWidget {
  final PositionedEvent positionedEvent;

  const DayViewEventTile({super.key, required this.positionedEvent});

  String title(){
   if (positionedEvent.events.length == 1) return positionedEvent.events.first.title;
   String title = "";
   for (final event in positionedEvent.events) {
     title += "${event.title}\n";
   }
   return title;
  }

  @override
  Widget build(BuildContext context) {
    final event = positionedEvent.events;
    return Positioned(
      top: positionedEvent.top,
      left: positionedEvent.left,
      width: positionedEvent.width,
      height: positionedEvent.height,
      child: GestureDetector(
        onTap: () => _showEventDetails(context, event),
        onLongPress: () => _showTooltip(context, event),
        child: Container(
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.9),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            title(),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
  }

  void _showTooltip(BuildContext context, List<CalendarEvent> events) {
    if (events.length == 1) {
      ShowUtils.tooltipSingleEvent(context, events.first);
      return;
    }
    ShowUtils.tooltipMulEvent(context, events);
  }

  void _showEventDetails(BuildContext context, List<CalendarEvent> events) {
    if (events.length == 1) {
      ShowUtils.showSingleEventDetails(context, events.first);
      return;
    }
    ShowUtils.showEventsDetails(context, events);
  }

}