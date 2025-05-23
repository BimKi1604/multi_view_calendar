DateTime startOfMonth(DateTime date) {
  return DateTime(date.year, date.month, 1);
}

List<DateTime> daysInMonthGrid(DateTime firstDayOfMonth) {
  final firstWeekday = firstDayOfMonth.weekday; // Monday = 1
  final daysBefore = firstWeekday - 1;

  final start = firstDayOfMonth.subtract(Duration(days: daysBefore));

  return List.generate(
    42,
        (index) => start.add(Duration(days: index)),
  );
}
