import 'package:flutter/material.dart';

/// Model calendar events
class CalendarEvent {
  final String id;
  final String title;
  final DateTime start;
  final DateTime end;
  final Color? color;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    this.color,
  });
}