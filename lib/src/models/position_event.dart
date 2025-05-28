import 'package:multi_view_calendar/src/models/calendar_event.dart';

/// model help overlap events
class PositionedEvent {
  final CalendarEvent event;
  final double top;
  final double height;
  final double left;
  final double width;

  PositionedEvent({
    required this.event,
    required this.top,
    required this.height,
    required this.left,
    required this.width,
  });
}