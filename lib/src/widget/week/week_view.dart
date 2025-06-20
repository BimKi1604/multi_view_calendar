import 'dart:async';
import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/data/data.dart';
import 'package:multi_view_calendar/src/models/calendar_event.dart';
import 'package:multi_view_calendar/src/utils/click_utils.dart';
import 'package:multi_view_calendar/src/utils/show_utils.dart';
import 'package:multi_view_calendar/src/utils/time_utils.dart';
import 'package:multi_view_calendar/src/widget/day/day_view.dart';
import 'package:multi_view_calendar/src/widget/elements/event_action.dart';
import 'package:multi_view_calendar/src/widget/elements/time_column.dart';
import 'package:multi_view_calendar/src/widget/week/week_selector.dart';

import 'week_row_item.dart';

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
  late DateTime weekStartDate;
  ScrollController controller = ScrollController();
  ScrollController bodyController = ScrollController();
  late final Timer _timer;

  @override
  void initState() {
    bodyController.addListener(() {
      controller.jumpTo(bodyController.offset);
    });
    weekStartDate = widget.weekStartDate;
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

  void _onActionEvent() async {
    ShowUtils.showFullScreenDialog(context, child: const EventAction());
  }

  void _onSelectWeek(DateTime startWeek, DateTime endWeek) {
    setState(() {
      weekStartDate = startWeek;
    });
    controller.jumpTo(0);
    bodyController.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final days = List.generate(
      7,
          (index) => weekStartDate.add(Duration(days: index)),
    );
    return Stack(
      children: [
        Column(
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
            LazyWeekSelector(
              selectedDate: weekStartDate,
              setSelectedWeek: (start, end) {
                setState(() {
                  _onSelectWeek(start, end);
                });
              },
            ),
            const SizedBox(height: 10.0,),
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
                          return WeekRowItem(date: date);
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
                              const TimeColumn(),

                              // Scrollable horizontal day columns
                              Expanded(
                                child: SingleChildScrollView(
                                  controller: bodyController,
                                  scrollDirection: Axis.horizontal,
                                  child: RepaintBoundary(
                                    child: Row(
                                      children: days.map((day) {
                                        return Container(
                                          width: DataApp.widthEvent,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              right: BorderSide(
                                                color: DataApp.borderColor,
                                                width: 1,
                                              )
                                            ),
                                          ),
                                          child: DayView(
                                            key: ValueKey(day),
                                            date: day,
                                            onlyDay: false,
                                            events: widget.events,
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
        ),
        Positioned(
          bottom: 15,
          right: 15,
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: DataApp.mainColor
            ),
            child: ClickUtils(
              onTap: (){
                _onActionEvent();
              },
              borderRadius: BorderRadius.circular(50.0),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.add, color: Colors.white, size: 26),
              ),
            ),
          ),
        )
      ],
    );
  }

  String _weekRangeText(DateTime start, DateTime end) {
    format(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
    return 'Week: ${format(start)} - ${format(end)}';
  }
}
