import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/models/calendar_event.dart';

/// class helper for show widget
class ShowUtils {
  static void tooltipSingleEvent(BuildContext context, CalendarEvent event, Color color) {
    final text = 'From: ${event.start.hour}:${event.start.minute.toString().padLeft(2, '0')}\n'
        'To: ${event.end.hour}:${event.end.minute.toString().padLeft(2, '0')}';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: color,
        title: Text(event.title, style: const TextStyle(color: Colors.white),),
        content: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  static void tooltipMulEvent(BuildContext context, List<CalendarEvent> events, Color color) {
    List<Widget> content = [];
    for (final event in events) {
      final text = 'From: ${event.start.hour}:${event.start.minute.toString().padLeft(2, '0')}\n'
          'To: ${event.end.hour}:${event.end.minute.toString().padLeft(2, '0')}';
      content = [...content, Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5.0),
          Text(event.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 5.0),
          Text(text, style: const TextStyle(fontSize: 12, color: Colors.white)),
        ],
      )];
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: color,
        title: const Text("Events", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: content,
        ),
      ),
    );
  }

  static void showSingleEventDetails(BuildContext context, CalendarEvent event, Color color) {
    showModalBottomSheet(
      backgroundColor: color,
      context: context,
      builder: (_) => Padding(
          padding: const EdgeInsets.all(16),
          child: _detailEvent(event, paddingBottom: false)
      ),
    );
  }

  static Widget _detailEvent(CalendarEvent event, {bool paddingBottom = true}) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(event.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      const SizedBox(height: 8),
      Text('Start: ${event.start}', style: const TextStyle(color: Colors.white)),
      Text('End: ${event.end}', style: const TextStyle(color: Colors.white)),
      Visibility(
          visible: paddingBottom,
          child: const SizedBox(height: 10.0)
      )
    ],
  );

  static void showEventsDetails(BuildContext context, List<CalendarEvent> events, Color color) {
    showModalBottomSheet(
      backgroundColor: color,
      context: context,
      builder: (_) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: events.map((event) =>  _detailEvent(event, paddingBottom: event == events.last ? false : true )).toList(),
          )
      ),
    );
  }
}