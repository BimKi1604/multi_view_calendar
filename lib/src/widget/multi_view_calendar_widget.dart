import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/data/calendar_event.dart';
import 'package:multi_view_calendar/src/data/calendar_view_type.dart';
import 'calendar_header.dart';
import 'day_view.dart';
import 'month_week.dart';
import 'week_view.dart';
import 'year_view.dart';

class MultiViewCalendar extends StatefulWidget {
  final DateTime initialDate;
  final List<CalendarEvent> events;

  const MultiViewCalendar({
    super.key,
    required this.initialDate,
    required this.events,
  });

  @override
  State<MultiViewCalendar> createState() => _MultiViewCalendarState();
}

class _MultiViewCalendarState extends State<MultiViewCalendar> {
  late DateTime _currentDate;
  CalendarViewType _currentView = CalendarViewType.month;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.initialDate;
  }

  void _goToPrevious() {
    setState(() {
      switch (_currentView) {
        case CalendarViewType.day:
          _currentDate = _currentDate.subtract(const Duration(days: 1));
          break;
        case CalendarViewType.week:
          _currentDate = _currentDate.subtract(const Duration(days: 7));
          break;
        case CalendarViewType.month:
          _currentDate = DateTime(_currentDate.year, _currentDate.month - 1, 1);
          break;
        case CalendarViewType.year:
          _currentDate = DateTime(_currentDate.year - 1, 1, 1);
          break;
      }
    });
  }

  void _goToNext() {
    setState(() {
      switch (_currentView) {
        case CalendarViewType.day:
          _currentDate = _currentDate.add(const Duration(days: 1));
          break;
        case CalendarViewType.week:
          _currentDate = _currentDate.add(const Duration(days: 7));
          break;
        case CalendarViewType.month:
          _currentDate = DateTime(_currentDate.year, _currentDate.month + 1, 1);
          break;
        case CalendarViewType.year:
          _currentDate = DateTime(_currentDate.year + 1, 1, 1);
          break;
      }
    });
  }

  void _goToToday() {
    setState(() {
      _currentDate = DateTime.now();
    });
  }

  void _changeView(CalendarViewType mode) {
    setState(() {
      _currentView = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget view;

    switch (_currentView) {
      case CalendarViewType.day:
        view = DayView(date: _currentDate, events: widget.events);
        break;
      case CalendarViewType.week:
        view = WeekView(weekStartDate: _currentDate, events: widget.events);
        break;
      case CalendarViewType.month:
        view = MonthView(month: _currentDate, events: widget.events);
        break;
      case CalendarViewType.year:
        view = YearView(year: _currentDate, events: widget.events);
        break;
    }

    return Column(
      children: [
        CalendarHeader(
          currentDate: _currentDate,
          currentView: _currentView,
          onPrevious: _goToPrevious,
          onNext: _goToNext,
          onToday: _goToToday,
          onViewChange: _changeView,
        ),
        const Divider(height: 1),
        Expanded(child: view),
      ],
    );
  }
}
