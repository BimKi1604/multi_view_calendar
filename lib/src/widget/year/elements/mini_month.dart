import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/data/data.dart';
import 'package:multi_view_calendar/src/utils/time_utils.dart';
import 'package:shimmer_effects_plus/shimmer_effects_plus.dart';

class MiniMonth extends StatefulWidget {
  final int year;
  final int month;

  const MiniMonth({super.key, required this.year, required this.month});

  @override
  State<MiniMonth> createState() => _MiniMonthState();
}

class _MiniMonthState extends State<MiniMonth> {
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.month * 140), () {
      if (mounted) setState(() => _loaded = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return ShimmerEffectWidget.cover(
        subColor: Colors.grey[300]!,
        mainColor: Colors.grey[100]!,
        period: const Duration(milliseconds: 260),
        direction: ShimmerDirection.ttb,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          margin: const EdgeInsets.all(5.0),
        ),
      );
    }

    final firstDay = DateTime(widget.year, widget.month, 1);
    final totalDays = DateUtils.getDaysInMonth(widget.year, widget.month);
    final startWeekday = firstDay.weekday;

    final days = List<DateTime?>.filled(startWeekday - 1, null) +
        List.generate(
            totalDays, (i) => DateTime(widget.year, widget.month, i + 1));

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
            TimeUtils.monthLabel(widget.month),
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
                    decoration: DateUtils.isSameDay(day, DateTime.now())
                        ? BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: DataApp.mainColor,
                            ),
                            borderRadius: BorderRadius.circular(3.0),
                          )
                        : null,
                    child: Text(
                      day?.day.toString() ?? '',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: day?.weekday == DateTime.sunday
                            ? Colors.red
                            : Colors.black87,
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
