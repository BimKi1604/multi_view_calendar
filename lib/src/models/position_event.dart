import 'package:multi_view_calendar/src/models/calendar_event.dart';

/// model help overlap events
class PositionedEvent {
  final double top;
  final double height;
  final double left;
  final double width;
  final List<CalendarEvent> events;

  PositionedEvent({
    required this.top,
    required this.height,
    required this.left,
    required this.width,
    this.events = const [],
  });
}