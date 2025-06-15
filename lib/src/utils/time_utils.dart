
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/data/data.dart';

import '../models/calendar_event.dart';
import 'package:intl/intl.dart';

class TimeUtils {
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static List<DateTime> daysInMonthGrid(DateTime firstDayOfMonth) {
    final firstWeekday = firstDayOfMonth.weekday; // Monday = 1
    final daysBefore = firstWeekday - 1;

    final start = firstDayOfMonth.subtract(Duration(days: daysBefore));

    return List.generate(
      42,
          (index) => start.add(Duration(days: index)),
    );
  }

  static String weekdayLabel(int weekday) {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return labels[(weekday - 1) % 7];
  }

  static bool isToday(DateTime day) {
    final DateTime now = DateTime.now();
    return DateUtils.isSameDay(now, day);
  }

  static bool isPassDay(DateTime a, DateTime b) {
    if (a.day != b.day) return true;
    return false;
  }

  static double get currentTimeTop {
    final now = DateTime.now();
    final minutes = now.hour * 60 + now.minute;
    final minutesHeight = DataApp.heightEvent / 60; /// pixel each minute
    return minutes * minutesHeight;
  }

  static List<CalendarEvent> getEventDay({ required DateTime day, required List<CalendarEvent> totalEvents }) {
    List<CalendarEvent> events = List.empty(growable: true);
    List<CalendarEvent> eventsPreDay = List.empty(growable: true);

    /// Get events for the specific day and the previous day
    for (final event in totalEvents) {
      if (DateUtils.isSameDay(event.start, day)) {
        events.add(event);
        continue;
      }
      if (DateUtils.isSameDay(event.start, day.subtract(const Duration(days: 1)))) {
        eventsPreDay.add(event);
        continue;
      }
    }

    /// Filter events that pass the day
    for (final event in eventsPreDay) {
      if (!TimeUtils.isPassDay(event.start, event.end)) continue;
      events.add(event.copyWith(start: DateTime(event.end.year, event.end.month, event.end.day, 0, 0)));
    }

    return events;
  }

  /// Convert DateTime to a short weekday label (e.g., "Mo", "Tu")
  static String dateTimeToShortWeekday(DateTime date) {
    const labels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return labels[(date.weekday - 1) % 7];
  }

  /// Format date to 'dd/MM/yyyy'
  static String formatMonthYear(DateTime date, {String format = 'MMMM, yyyy'}) {
    return DateFormat(format).format(date);
  }

  static String monthLabel(int month) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return monthNames[month - 1];
  }

  static Future<DateTime?> showDateTimePicker(BuildContext context, DateTime? initial) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );

    if (pickedDate == null) return null;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial ?? now),
    );

    if (pickedTime == null) return null;

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }

  static String generateSimpleId() {
    final rand = Random();
    return '${DateTime.now().millisecondsSinceEpoch}_${rand.nextInt(10000)}';
  }

  static bool isSameWeek(DateTime a, DateTime b) {
    final mondayA = a.subtract(Duration(days: a.weekday - 1));
    final mondayB = b.subtract(Duration(days: b.weekday - 1));
    return mondayA.year == mondayB.year && mondayA.month == mondayB.month && mondayA.day == mondayB.day;
  }
}

