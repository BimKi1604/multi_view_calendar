import 'package:flutter/material.dart';

import '../data/data.dart';

/// Model calendar events
class CalendarEvent {
  final String id;
  final String title;
  final DateTime start;
  final DateTime end;
  final Color? color;
  final String? description;
  final String? location;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    this.color,
    this.description,
    this.location,
  });

  CalendarEvent copyWith({
    String? id,
    String? title,
    DateTime? start,
    DateTime? end,
    Color? color,
    String? description,
    String? location,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      start: start ?? this.start,
      end: end ?? this.end,
      color: color ?? this.color,
      description: description ?? this.description,
      location: location ?? this.location,
    );
  }

  static CalendarEvent defaultEvent() {
    return CalendarEvent(
      id: '-1',
      title: '',
      start: DateTime.now(),
      end: DateTime.now().add(const Duration(hours: 1)),
      color: DataApp.mainColor,
      description: '',
      location: '',
    );
  }

  static CalendarEvent emptyEvent() {
    return CalendarEvent(
      id: '',
      title: '',
      start: DateTime.now(),
      end: DateTime.now(),
      color: Colors.transparent,
      description: '',
      location: '',
    );
  }
}
