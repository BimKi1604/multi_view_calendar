import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/multi_view_calendar.dart';

import 'month_week_state.dart';

class MonthView extends StatefulWidget {
  final DateTime month;
  final List<CalendarEvent> events;

  const MonthView({
    super.key,
    required this.month,
    required this.events,
  });

  @override
  State<MonthView> createState() => MonthViewState();
}

