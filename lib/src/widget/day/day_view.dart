import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/models/calendar_event.dart';

import 'day_view_state.dart';

class DayView extends StatefulWidget {
  final DateTime date;
  final List<CalendarEvent> events;
  final bool showTimeLabels;
  final bool onlyDay;

  /// Just show itself

  const DayView({
    super.key,
    required this.date,
    required this.events,
    this.showTimeLabels = true,
    this.onlyDay = true,
  });

  @override
  State<DayView> createState() => DayViewState();
}
