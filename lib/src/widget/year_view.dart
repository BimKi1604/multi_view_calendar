import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/data/data.dart';
import 'package:multi_view_calendar/src/utils/time_utils.dart';

class YearView extends StatelessWidget {
  final int year;

  const YearView({super.key, required this.year});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            year.toString(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0,),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            padding: const EdgeInsets.all(8),
            childAspectRatio: 0.85,
            children: List.generate(12, (index) {
              final month = index + 1;
              return _buildMonth(context, year, month);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMonth(BuildContext context, int year, int month) {
    final firstDay = DateTime(year, month, 1);
    final totalDays = DateUtils.getDaysInMonth(year, month);
    final startWeekday = firstDay.weekday; // 1 = Monday => 7 = Sunday

    final days = <DateTime?>[];

    // Add empty boxes for days before the 1st
    for (int i = 1; i < startWeekday; i++) {
      days.add(null);
    }

    // Add all days of the month
    for (int i = 1; i <= totalDays; i++) {
      days.add(DateTime(year, month, i));
    }

    Color getColorForWeekday(DateTime? day) {
      if (day == null) return Colors.transparent;
      if (day.weekday == DateTime.sunday) {
        return Colors.red; // Sunday
      }
      return Colors.black87;
    }

    return Container(
      padding: const EdgeInsets.all(1),
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Text(
            TimeUtils.monthLabel(month),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          _buildWeekdaysHeader(),
          const SizedBox(height: 4),
          Expanded(
            child: GridView.builder(
              itemCount: days.length,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                final day = days[index];
                return Center(
                  child: Container(
                    decoration: DateUtils.isSameDay(day, DateTime.now()) ? BoxDecoration( // Highlight today's date
                      border: Border.all(
                        width: 1,
                        color: DataApp.mainColor
                      ),
                      borderRadius: BorderRadius.circular(3.0)
                    ) : null,
                    child: Text(
                      day?.day.toString() ?? '',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: getColorForWeekday(day),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdaysHeader() {
    const weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    return Row(
      children: weekdays.map((w) {
        return Expanded(
          child: Center(
            child: Text(
              w,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: w == "CN" ? Colors.red : Colors.grey,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
