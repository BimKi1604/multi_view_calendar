import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/data/calendar_view_type.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime currentDate;
  final CalendarViewType currentView;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;
  final ValueChanged<CalendarViewType> onViewChange;

  const CalendarHeader({
    super.key,
    required this.currentDate,
    required this.currentView,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
    required this.onViewChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: [
          const Text(
            "Select type",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          DropdownButton<CalendarViewType>(
            value: currentView,
            onChanged: (type) {
              if (type == null) return;
              onViewChange(type);
            },
            items: CalendarViewType.values.map((view) {
              return DropdownMenuItem(
                value: view,
                child: Text(view.name.toUpperCase()),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
