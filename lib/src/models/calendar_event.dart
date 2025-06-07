import 'package:flutter/material.dart';

import '../data/data.dart';

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

  CalendarEvent copyWith({
    String? id,
    String? title,
    DateTime? start,
    DateTime? end,
    Color? color,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      start: start ?? this.start,
      end: end ?? this.end,
      color: color ?? this.color,
    );
  }

  static CalendarEvent defaultEvent() {
    return CalendarEvent(
      id: '-1',
      title: '',
      start: DateTime.now(),
      end: DateTime.now().add(const Duration(hours: 1)),
      color: DataApp.mainColor,
    );
  }

  static CalendarEvent emptyEvent() {
    return CalendarEvent(
      id: '',
      title: '',
      start: DateTime.now(),
      end: DateTime.now(),
      color: Colors.transparent,
    );
  }

}