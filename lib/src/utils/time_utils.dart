
import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/data/data.dart';

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

  static double get currentTimeTop {
    final now = DateTime.now();
    final minutes = now.hour * 60 + now.minute;
    final minutesHeight = DataApp.heightEvent / 60; /// pixel each minute
    return minutes * minutesHeight;
  }
}

