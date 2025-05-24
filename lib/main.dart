import 'package:flutter/material.dart';
import 'src/data/calendar_event.dart';
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
    // Demo events
    final events = [
      CalendarEvent(
        id: "1",
        title: 'Meeting with team',
        start: DateTime.now().subtract(const Duration(days: 1)),
        end: DateTime.now().subtract(const Duration(days: 1)),
      ),
      CalendarEvent(
        id: "2.5",
        title: 'Calling with team',
        start: DateTime.now().add(const Duration(days: 2)),
        end: DateTime.now().add(const Duration(days: 2)),
      ),
      CalendarEvent(
        id: "2",
        title: 'Doctor appointment',
        start: DateTime.now().add(const Duration(days: 2)),
        end: DateTime.now().add(const Duration(days: 2)),
      ),
      CalendarEvent(
        id: "2.6",
        title: 'Calling appointment',
        start: DateTime.now().add(const Duration(days: 2)),
        end: DateTime.now().add(const Duration(days: 2)),
      ),
      CalendarEvent(
        id: "3",
        title: 'Project deadline',
        start: DateTime.now().add(const Duration(days: 3, hours: 1)),
        end: DateTime.now().add(const Duration(days: 3, hours: 1)),
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
