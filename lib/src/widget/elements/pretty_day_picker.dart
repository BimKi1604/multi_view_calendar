import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_view_calendar/src/data/calendar_view_type.dart';
import 'package:multi_view_calendar/src/data/data.dart';
import 'package:multi_view_calendar/src/utils/click_utils.dart';

class PrettyDayPicker extends StatefulWidget {
  final DateTime initialDate;

  const PrettyDayPicker({
    super.key,
    required this.initialDate,
  });

  @override
  State<PrettyDayPicker> createState() => _PrettyDayPickerState();
}

class _PrettyDayPickerState extends State<PrettyDayPicker> {
  late DateTime _selectedDate;
  late DateTime _firstDayOfMonth;
  late int _daysInMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    _daysInMonth = DateUtils.getDaysInMonth(_selectedDate.year, _selectedDate.month);
  }

  void onChangedDayOfMonth(ChangedDay change) {
    if (!mounted) return;
    setState(() {
      _selectedDate = DateTime(
        change == ChangedDay.increase
            ? _selectedDate.year + (_selectedDate.month == 12 ? 1 : 0)
            : _selectedDate.year - (_selectedDate.month == 1 ? 1 : 0),
        change == ChangedDay.increase
            ? (_selectedDate.month % 12) + 1
            : (_selectedDate.month == 1 ? 12 : _selectedDate.month - 1),
        1,
      );
    });

    _firstDayOfMonth = _selectedDate;
    _daysInMonth = DateUtils.getDaysInMonth(_selectedDate.year, _selectedDate.month);
  }

  @override
  Widget build(BuildContext context) {
    final weekdayOffset = _firstDayOfMonth.weekday - 1; // Monday = 1

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClickUtils(
                  onTap: (){
                    onChangedDayOfMonth(ChangedDay.decrease);
                  },
                  borderRadius: BorderRadius.circular(50.0),
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 1, color: Colors.grey.shade400)
                    ),
                    child: const Icon(Icons.chevron_left, size: 21, color: Colors.black),
                  )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7.5),
                child: Text(
                  DateFormat('MMMM yyyy').format(_firstDayOfMonth),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ClickUtils(
                  onTap: (){
                    onChangedDayOfMonth(ChangedDay.increase);
                  },
                  borderRadius: BorderRadius.circular(50.0),
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 1, color: Colors.grey.shade400)
                    ),
                    child: const Icon(Icons.chevron_right, size: 21, color: Colors.black),
                  )
              ),
            ],
          ),
        ),
        _buildWeekdayLabels(),
        GridView.builder(
          shrinkWrap: true,
          itemCount: _daysInMonth + weekdayOffset,
          padding: const EdgeInsets.all(8),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          itemBuilder: (context, index) {
            if (index < weekdayOffset) {
              return const SizedBox(); // empty box before 1st
            }

            final day = index - weekdayOffset + 1;
            final date = DateTime(_firstDayOfMonth.year, _firstDayOfMonth.month, day);
            final isSelected = DateUtils.isSameDay(date, _selectedDate);
            final isToday = DateUtils.isSameDay(date, DateTime.now());

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDate = date;
                });
                Navigator.of(context).pop(_selectedDate);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? DataApp.mainColor : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: isToday ? Border.all(color: Colors.redAccent, width: 1.2) : null,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      day.toString(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    // Positioned(
                    //   top: 10,
                    //   child: Text("Today", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: DataApp.mainColor))
                    // )
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWeekdayLabels() {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Row(
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
        );
      }).toList(),
    );
  }
}
