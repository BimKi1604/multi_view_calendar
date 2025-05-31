import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/models/calendar_event.dart';

/// class helper for show widget
class ShowUtils {
  static void tooltipSingleEvent(BuildContext context, CalendarEvent event) {
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

  static void tooltipMulEvent(BuildContext context, List<CalendarEvent> events) {
    List<Widget> content = [];
    for (final event in events) {
      final text = 'From: ${event.start.hour}:${event.start.minute.toString().padLeft(2, '0')}\n'
          'To: ${event.end.hour}:${event.end.minute.toString().padLeft(2, '0')}';
      content = [...content, Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5.0),
          Text(event.title, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10.0),
          Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
        ],
      )];
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Events"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: content,
        ),
      ),
    );
  }

  static void showSingleEventDetails(BuildContext context, CalendarEvent event) {
    showModalBottomSheet(
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
      Text(event.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Text('Start: ${event.start}'),
      Text('End: ${event.end}'),
      Visibility(
          visible: paddingBottom,
          child: const SizedBox(height: 10.0)
      )
    ],
  );

  static void showEventsDetails(BuildContext context, List<CalendarEvent> events) {
    showModalBottomSheet(
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