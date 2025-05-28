import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/models/calendar_event.dart';
import 'package:multi_view_calendar/src/models/position_event.dart';

class DayViewEventTile extends StatelessWidget {
  final PositionedEvent positionedEvent;

  const DayViewEventTile({super.key, required this.positionedEvent});

  @override
  Widget build(BuildContext context) {
    final event = positionedEvent.event;
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
            event.title,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
  }

  void _showTooltip(BuildContext context, CalendarEvent event) {
    final text = 'From: ${event.start.hour}:${event.start.minute.toString().padLeft(2, '0')}\n'
        'To: ${event.end.hour}:${event.end.minute.toString().padLeft(2, '0')}';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(event.title),
        content: Text(text),
      ),
    );
  }

  void _showEventDetails(BuildContext context, CalendarEvent event) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Start: ${event.start}'),
            Text('End: ${event.end}'),
          ],
        ),
      ),
    );
  }
}