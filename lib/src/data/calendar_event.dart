/// Model calendar events
class CalendarEvent {
  final String id;
  final String title;
  final DateTime start;
  final DateTime end;
  final String? description;
  final String? location;
  final int? color;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    this.description,
    this.location,
    this.color,
  });
}