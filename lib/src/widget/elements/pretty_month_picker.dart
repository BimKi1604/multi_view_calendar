import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/utils/time_utils.dart';

class PrettyMonthPicker extends StatefulWidget {
  const PrettyMonthPicker({super.key, required this.initialDate});

  final DateTime initialDate;

  @override
  State<PrettyMonthPicker> createState() => _PrettyMonthPickerState();
}

class _PrettyMonthPickerState extends State<PrettyMonthPicker> {
  late DateTime tempDate;
  late int selectedYear;

  @override
  void initState() {
    tempDate = DateTime(widget.initialDate.year, widget.initialDate.month);
    selectedYear = tempDate.year;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: 340,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // YEAR HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 28),
                onPressed: () => setState(() => selectedYear--),
              ),
              Text(
                '$selectedYear',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 28),
                onPressed: () => setState(() => selectedYear++),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // MONTH GRID
          GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            shrinkWrap: true,
            children: List.generate(12, (index) {
              final month = index + 1;
              final isCurrentMonth = month == DateTime.now().month &&
                  selectedYear == DateTime.now().year;

              return GestureDetector(
                onTap: () =>
                    Navigator.of(context).pop(DateTime(selectedYear, month)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isCurrentMonth
                        ? Colors.blueAccent.withOpacity(0.2)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isCurrentMonth ? Colors.blue : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    TimeUtils.monthLabel(month),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isCurrentMonth ? Colors.blue : Colors.black87,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
