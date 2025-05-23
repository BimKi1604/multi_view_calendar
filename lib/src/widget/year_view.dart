import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/data/calendar_event.dart';
import 'package:multi_view_calendar/src/widget/month_week.dart';

class YearView extends StatelessWidget {
  final DateTime year;
  final List<CalendarEvent> events;

  const YearView({
    super.key,
    required this.year,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final months = List.generate(12, (i) => DateTime(year.year, i + 1, 1));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            '${year.year}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: GridView.builder(
            itemCount: 12,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 cột: 4 hàng
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.2,
            ),
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final month = months[index];
              final monthEvents = events.where((e) =>
              e.start.year == month.year && e.start.month == month.month).toList();

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: InkWell(
                  onTap: () {
                    // Tùy chọn: mở full MonthView nếu bạn muốn
                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        child: SizedBox(
                          height: 500,
                          child: MonthView(
                            month: month,
                            events: monthEvents,
                          ),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(
                          _monthName(month.month),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${monthEvents.length} events',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _monthName(int month) {
    const names = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return names[month - 1];
  }
}
