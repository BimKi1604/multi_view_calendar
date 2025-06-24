import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/data/data.dart';
import 'package:multi_view_calendar/src/models/calendar_event.dart';
import 'package:multi_view_calendar/src/utils/show_utils.dart';
import 'package:multi_view_calendar/src/utils/time_utils.dart';
import 'package:multi_view_calendar/src/widget/elements/pretty_month_picker.dart';
import 'package:multi_view_calendar/src/widget/month/elements/month_body.dart';
import 'package:multi_view_calendar/src/widget/elements/weekday_header.dart';
import 'package:multi_view_calendar/src/widget/month/elements/month_event_tile.dart';
import 'package:multi_view_calendar/src/widget/month/elements/month_header.dart';
import 'package:multi_view_calendar/src/widget/month/elements/month_title_task.dart';
import 'package:multi_view_calendar/src/widget/month/month_week.dart';

import '../elements/event_action.dart';

class MonthViewState extends State<MonthView> {

  DateTime initDate = DateTime.now();
  DateTime? selectedDate;

  @override
  void initState() {
    initDate = widget.month;
    super.initState();
  }

  void _onDaySelected(DateTime day) {
    if (selectedDate == day) return;
    if (!mounted) return;

    setState(() {
      selectedDate = day;
    });
  }

  Decoration _dayDecoration(DateTime day) {
    if (day == selectedDate) {
      return BoxDecoration(
        color: DataApp.mainColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Colors.lightBlueAccent,
            spreadRadius: 0,
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
        ],
      );
    }
    if (TimeUtils.isToday(day)) {
      return BoxDecoration(
        border: Border.all(width: 1, color: DataApp.mainColor.withOpacity(.4)),
        borderRadius: BorderRadius.circular(5),
      );
    }

    return const BoxDecoration();
  }

  Color? _getEventColor(DateTime day) {
    if (day == selectedDate) return Colors.white;

    final isOutsideMonth = day.month != initDate.month;
    if (isOutsideMonth) {
      return Colors.grey[350];
    }

    return Colors.black;
  }

  List<CalendarEvent> _getEventsForDay() {
    if (selectedDate == null) return [];

    return widget.events.where((event) {
      return DateUtils.isSameDay(event.start, selectedDate);
    }).toList();
  }

  void _onOpenSelectMonth(BuildContext context) async {
    DateTime? month = await ShowUtils.showDialogWidget(
      context: context,
      child: PrettyMonthPicker(
        initialDate: initDate,
      ),
    );
    if (month == null) return;
    if (!mounted) return;
    setState(() {
      initDate = month;
      selectedDate = null; // Reset selected date when month changes
    });
  }

  void _onAddEvent() {
    ShowUtils.showFullScreenDialog(context, child: const EventAction());
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = TimeUtils.startOfMonth(initDate);
    final days = TimeUtils.daysInMonthGrid(firstDayOfMonth);
    final events = _getEventsForDay();

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20.0),
          Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.7),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MonthHeader(
                  month: initDate,
                  onMonthSelected: (date) {
                    _onOpenSelectMonth(context);
                  },
                ),
                const WeekdayHeader(),
                const SizedBox(height: 5.0,),
                MonthBody(
                  days: days,
                  events: widget.events,
                  onDaySelected: _onDaySelected,
                  dayDecoration: _dayDecoration,
                  getEventColor: _getEventColor,
                ),
              ],
            ),
          ),
          MonthTitleTask(
            onAdd: () async {
              _onAddEvent();
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              TimeOfDay timeOfDay = TimeOfDay.fromDateTime(event.start);
              return MonthEventTile(
                title: event.title,
                start: event.start,
                end: event.end,
                time: timeOfDay,
                isFirst: index == 0,
                isLast: index == events.length - 1,
                callback: () {
                  ShowUtils.showFullScreenDialog(context, child: EventAction(event: event));
                },
              );
            },
          )
        ],
      ),
    );
  }
}
