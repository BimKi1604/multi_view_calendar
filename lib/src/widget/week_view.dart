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

  List<CalendarEvent> getEventDay(DateTime day) {
    List<CalendarEvent> events = List.empty(growable: true);
    List<CalendarEvent> eventsPreDay = List.empty(growable: true);

    for (final event in widget.events) {
      if (DateUtils.isSameDay(event.start, day)) {
        events.add(event);
        continue;
      }
      if (DateUtils.isSameDay(event.start, day.subtract(const Duration(days: 1)))) {
        eventsPreDay.add(event);
        continue;
      }
    }

    for (final event in eventsPreDay) {
      if (!TimeUtils.isPassDay(event.start, event.end)) continue;
      events.add(event.copyWith(start: DateTime(event.end.year, event.end.month, event.end.day, 0, 0)));
    }

    return events;
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
                                      child: Icon(Icons.today, color: DataApp.iconColor, size: 11,)
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
                  child: Stack(
                    children: [
                      Positioned(
                        top: TimeUtils.currentTimeTop - 3,
                        left: DataApp.widthTimeColumn - 11,
                        right: 0,
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: DataApp.iconColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1.5,
                                color: DataApp.iconColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Time Column
                          _buildTimeColumn(),

                          // Scrollable horizontal day columns
                          Expanded(
                            child: SingleChildScrollView(
                              controller: bodyController,
                              scrollDirection: Axis.horizontal,
                              child: RepaintBoundary(
                                child: Row(
                                  children: days.map((day) {
                                    final dayEvents = getEventDay(day);
                                    return Container(
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
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
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
      padding: const EdgeInsets.only(right: 10.0),
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
