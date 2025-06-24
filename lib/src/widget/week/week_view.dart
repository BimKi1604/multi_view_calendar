import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/models/calendar_event.dart';
import 'package:multi_view_calendar/src/widget/week/week_view_state.dart';

class WeekView extends StatefulWidget {
  final DateTime weekStartDate;
  final List<CalendarEvent> events;

  const WeekView({
    super.key,
    required this.weekStartDate,
    required this.events,
  });

  @override
  State<WeekView> createState() => WeekViewState();
}
