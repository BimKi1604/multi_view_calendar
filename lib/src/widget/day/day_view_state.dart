import 'dart:async';
import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/models/calendar_event.dart';
import 'package:multi_view_calendar/src/widget/day/day_view.dart';
import 'package:multi_view_calendar/src/data/data.dart';
import 'package:multi_view_calendar/src/models/position_event.dart';
import 'package:multi_view_calendar/src/utils/click_utils.dart';
import 'package:multi_view_calendar/src/utils/show_utils.dart';
import 'package:multi_view_calendar/src/utils/time_utils.dart';
import 'package:multi_view_calendar/src/widget/day/elements/day_time_lines.dart';
import 'package:multi_view_calendar/src/widget/day/elements/day_view_event_tile.dart';
import 'package:multi_view_calendar/src/widget/day/elements/divider_time_now.dart';
import 'package:multi_view_calendar/src/widget/day/elements/lazy_week_view.dart';
import 'package:multi_view_calendar/src/widget/day/elements/select_event_group.dart';
import 'package:multi_view_calendar/src/widget/elements/pretty_day_picker.dart';
import 'package:multi_view_calendar/src/widget/elements/time_column.dart';
import 'package:multi_view_calendar/src/widget/elements/event_action.dart';

class DayViewState extends State<DayView> {
  late final Timer _timer;
  late DateTime _selectedDate;

  @override
  void initState() {
    if (widget.onlyDay) {
      _timer = Timer.periodic(const Duration(minutes: 1), (_) {
        if (mounted) setState(() {});
      });
    }
    _selectedDate = widget.date;
    super.initState();
  }

  void _setSelectedDate(DateTime newDate) {
    if (!mounted) return;
    setState(() {
      _selectedDate = newDate;
    });
  }

  @override
  void dispose() {
    if (widget.onlyDay) {
      _timer.cancel();
    }
    super.dispose();
  }

  void _onShowSelectedDate() async {
    DateTime? month = await ShowUtils.showDialogWidget(
        context: context,
        child: PrettyDayPicker(
          initialDate: _selectedDate,
        ),
        color: Colors.white);
    if (month == null) return;
    if (!mounted) return;
    setState(() {
      _selectedDate = month;
    });
  }

  void _onActionEvent({List<CalendarEvent>? events}) async {
    if (events != null) {
      CalendarEvent event = await ShowUtils.showDialogWidget(
          context: context,
          child: SelectEventGroup(
            events: events,
          ));
      if (!mounted) return;
      ShowUtils.showFullScreenDialog(context, child: EventAction(event: event));
      return;
    }
    ShowUtils.showFullScreenDialog(context, child: const EventAction());
  }

  @override
  Widget build(BuildContext context) {
    final List<CalendarEvent> eventsFilter = TimeUtils.getEventDay(
      day: _selectedDate,
      totalEvents: widget.events,
    );
    final List<PositionedEvent> positionedEvents =
        _calculateEventPositions(eventsFilter);
    final Size screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// header date
              Visibility(
                visible: widget.onlyDay,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ClickUtils(
                    onTap: () {
                      _onShowSelectedDate();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            TimeUtils.formatMonthYear(_selectedDate,
                                format: "MMM d, yyyy"),
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 2.0),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            size: 20,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              /// lazy scroll horizontal week view
              Visibility(
                visible: widget.onlyDay,
                child: LazyWeekView(
                  setSelected: (date) {
                    _setSelectedDate(date);
                  },
                  selectedDate: _selectedDate,
                ),
              ),

              /// body day view
              Stack(
                children: [
                  Visibility(
                    visible: widget.onlyDay,
                    child: const DividerTimeNow(),
                  ),
                  Row(
                    children: [
                      /// Left Time Column
                      Visibility(
                          visible: widget.onlyDay, child: const TimeColumn()),

                      /// Scrollable horizontal day columns
                      Expanded(
                        child: SizedBox(
                          width: screenSize.width,
                          child: Stack(
                            children: [
                              if (widget.showTimeLabels) const DayTimeLines(),
                              ...positionedEvents.map((e) => DayViewEventTile(
                                    positionedEvent: e,
                                    actionEvent: (events) {
                                      _onActionEvent(events: events);
                                    },
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Visibility(
          visible: widget.onlyDay,
          child: Positioned(
            bottom: 15,
            right: 15,
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: DataApp.mainColor),
              child: ClickUtils(
                onTap: () {
                  _onActionEvent();
                },
                borderRadius: BorderRadius.circular(50.0),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.add, color: Colors.white, size: 26),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  List<PositionedEvent> _calculateEventPositions(List<CalendarEvent> events) {
    final List<PositionedEvent> positioned = [];
    final double minuteHeight = DataApp.heightEvent / 60;
    final groups = _groupOverlappingEvents(events);

    /// group events by overlap

    for (final group in groups) {
      /// group events by overlap
      if (group.isEmpty) continue;

      /// skip empty groups
      final eventStartEarliest =
          group.reduce((a, b) => a.start.isBefore(b.start) ? a : b);

      /// find earliest start
      final eventEndLatest =
          group.reduce((a, b) => a.end.isAfter(b.end) ? a : b);

      /// find latest end
      final int startMinutes =
          eventStartEarliest.start.hour * 60 + eventStartEarliest.start.minute;
      final int endMinutes =
          (TimeUtils.isPassDay(eventStartEarliest.start, eventEndLatest.end)
                      ? (24 +
                          eventEndLatest.end
                              .difference(eventStartEarliest.start)
                              .inHours
                              .abs())
                      : eventEndLatest.end.hour) *
                  60 +
              eventEndLatest.end.minute;
      final double top = startMinutes * minuteHeight;
      final double height =
          (endMinutes - startMinutes).clamp(15.0, 1440.0) * minuteHeight;
      positioned.add(PositionedEvent(
        events: group,
        top: top,
        height: height,
        left: 0,
        width: DataApp.widthEvent,
      ));
    }
    return positioned;
  }

  List<List<CalendarEvent>> _groupOverlappingEvents(
      List<CalendarEvent> events) {
    final sorted = List<CalendarEvent>.from(events)
      ..sort((a, b) => a.start.compareTo(b.start));
    final List<List<CalendarEvent>> group = [];

    for (final event in sorted) {
      bool added = false;
      int index = -2;
      for (final groupOverlap in group) {
        index = groupOverlap.indexWhere((e) => _eventsOverlap(e, event));
        if (index != -1) {
          groupOverlap.add(event);
          added = true;
          break;
        }
      }
      if (!added) {
        group.add([event]);
      }
    }

    return group;
  }

  bool _eventsOverlap(CalendarEvent a, CalendarEvent b) {
    /// check event overlap
    if (!DateUtils.isSameDay(a.start, b.start)) return false;
    return a.start.isBefore(b.end) && b.start.isBefore(a.end);
  }
}
