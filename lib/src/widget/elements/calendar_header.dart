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
    final title = _buildTitle();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPrevious,
          ),
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: onToday,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onNext,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  String _buildTitle() {
    switch (currentView) {
      case CalendarViewType.day:
        return '${currentDate.year}-${_pad(currentDate.month)}-${_pad(currentDate.day)}';
      case CalendarViewType.week:
        final start = currentDate.subtract(Duration(days: currentDate.weekday - 1));
        final end = start.add(const Duration(days: 6));
        return '${_pad(start.month)}/${_pad(start.day)} - ${_pad(end.month)}/${_pad(end.day)}';
      case CalendarViewType.month:
        return '${currentDate.year}-${_pad(currentDate.month)}';
      case CalendarViewType.year:
        return '${currentDate.year}';
    }
  }

  String _pad(int value) => value.toString().padLeft(2, '0');
}