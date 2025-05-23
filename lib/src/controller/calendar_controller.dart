import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/data/calendar_event.dart';
import 'package:multi_view_calendar/src/data/calendar_view_type.dart';

/// Controller manage day/month/year display, manage event,
class CalendarController extends ChangeNotifier {
  DateTime _focusedDate;
  CalendarViewType _viewType;
  final List<CalendarEvent> _events;

  CalendarController({
    DateTime? initialDate,
    CalendarViewType initialView = CalendarViewType.month,
    List<CalendarEvent>? initialEvents,
  })  : _focusedDate = initialDate ?? DateTime.now(),
        _viewType = initialView,
        _events = initialEvents ?? [];

  DateTime get focusedDate => _focusedDate;
  CalendarViewType get viewType => _viewType;
  List<CalendarEvent> get events => List.unmodifiable(_events);

  void setFocusedDate(DateTime date) {
    _focusedDate = date;
    notifyListeners();
  }

  void setViewType(CalendarViewType view) {
    _viewType = view;
    notifyListeners();
  }

  void addEvent(CalendarEvent event) {
    _events.add(event);
    notifyListeners();
  }

  void removeEvent(String eventId) {
    _events.removeWhere((e) => e.id == eventId);
    notifyListeners();
  }

  void clearEvents() {
    _events.clear();
    notifyListeners();
  }
}
