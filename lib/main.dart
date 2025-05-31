import 'package:flutter/material.dart';
import 'src/models/calendar_event.dart';
import 'src/widget/multi_view_calendar_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi View Calendar Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalendarDemoPage(),
    );
  }
}

class CalendarDemoPage extends StatelessWidget {
  const CalendarDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    /// Demo events
    final now = DateTime.now();
    final events = [
      CalendarEvent(
        id: "2",
        title: 'Meeting with team',
        color: Colors.red,
        start: DateTime(now.year, now.month, now.day + 1, now.hour, 15),
        end: DateTime(now.year, now.month, now.day + 1, now.hour + 1, 15),
      ),
      CalendarEvent(
        id: "2.5",
        title: 'Calling with team',
        color: Colors.amber,
        start: DateTime(now.year, now.month, now.day + 2, now.hour, 15),
        end: DateTime(now.year, now.month, now.day + 2, now.hour + 2, 15),
      ),
      CalendarEvent(
        id: "2",
        title: 'Doctor appointment',
        color: Colors.blueAccent,
        start: DateTime(now.year, now.month, now.day + 2, now.hour, 15),
        end: DateTime(now.year, now.month, now.day + 2, now.hour + 1, 30),
      ),
      CalendarEvent(
        id: "3",
        title: 'Project deadline',
        color: Colors.deepOrange,
        start: now.add(const Duration(days: 3, hours: 2)),
        end: now.add(const Duration(days: 3, hours: 4)),
      ),
      CalendarEvent(
        id: "4",
        title: 'Test event',
        color: Colors.lightBlueAccent,
        start: DateTime(now.year, now.month, now.day, 9, 15),
        end: DateTime(now.year, now.month, now.day, 10, 30),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Multi View Calendar')),
      body: MultiViewCalendar(
        initialDate: DateTime.now(),
        events: events,
      ),
    );
  }
}
