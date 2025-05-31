import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/data/data.dart';
import 'package:multi_view_calendar/src/models/calendar_event.dart';
import 'package:multi_view_calendar/src/utils/show_utils.dart';
import 'package:multi_view_calendar/src/utils/time_utils.dart';
import 'package:multi_view_calendar/src/widget/day_view.dart';

class WeekView extends StatefulWidget {
  final DateTime weekStartDate;
  final List<CalendarEvent> events;

  const WeekView({
    super.key,
    required this.weekStartDate,
    required this.events,
  });

  @override
  State<WeekView> createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {

  ScrollController controller = ScrollController();
  ScrollController bodyController = ScrollController();
  DateTime now = DateTime.now();
  late final Timer _timer;

  @override
  void initState() {
    bodyController.addListener(() {
      controller.jumpTo(bodyController.offset);
    });
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    bodyController.dispose();
    _timer.cancel();
    super.dispose();
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final days = List.generate(
      7,
          (index) => widget.weekStartDate.add(Duration(days: index)),
    );


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            _weekRangeText(days.first, days.last),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        // Grid: Time column + Scrollable Day columns
        Expanded(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: DataApp.widthTimeColumn),
                height: DataApp.heightEvent,
                width: MediaQuery.sizeOf(context).width,
                child: ListView.builder(
                    controller: controller,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 7,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      final date = days[index];
                      return Container(
                        height: DataApp.heightEvent,
                        width: DataApp.widthEvent,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: const Border(
                            right: BorderSide(
                              width: 1,
                              color: Colors.white
                            )
                          ),
                          color: DataApp.mainColor,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 7.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${TimeUtils.weekdayLabel(date.weekday)}\n${date.day}/${date.month}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(width: 7.0),
                                Visibility(
                                  visible: TimeUtils.isToday(date),
                                    child: ShowUtils.eventWidget(
                                      child: const Icon(Icons.today, color: Colors.white, size: 11,)
                                    )
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Time Column
                      _buildTimeColumn(),

                      // Scrollable horizontal day columns
                      Expanded(
                        child: SingleChildScrollView(
                          controller: bodyController,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: days.map((day) {
                              final dayEvents = widget.events.where((e) => isSameDay(e.start, day)).toList();
                              return RepaintBoundary(
                                child: Stack(
                                  children: [
                                    Container(
                                      width: DataApp.widthEvent,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            color: DataApp.borderColor,
                                            width: 1,
                                          )
                                        )
                                      ),
                                      child: DayView(
                                        date: day,
                                        events: dayEvents,
                                      ),
                                    ),
                                    if (TimeUtils.isToday(day))
                                      Positioned(
                                        top: TimeUtils.currentTimeTop,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          height: 1.5,
                                          color: Colors.red,
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeColumn() {
    final hours = List.generate(24, (index) => index);
    return Container(
      width: DataApp.widthTimeColumn,
      padding: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: DataApp.borderColor,
          )
        )
      ),
      child: Column(
        children: hours.map((hour) {
          return SizedBox(
            height: DataApp.heightEvent,
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                '${hour.toString().padLeft(2, '0')}:00',
                style: TextStyle(fontSize: 12, color: DataApp.mainColor, fontWeight: FontWeight.w900),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _weekRangeText(DateTime start, DateTime end) {
    format(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
    return 'Week: ${format(start)} - ${format(end)}';
  }
}
