import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/data/calendar_event.dart';
import 'package:multi_view_calendar/src/data/day_data.dart';
import 'package:multi_view_calendar/src/utils/click_utils.dart';

class DayView extends StatefulWidget {
  final DateTime date;
  final List<CalendarEvent> events;
  final bool showTimeLabels;

  const DayView({
    super.key,
    required this.date,
    required this.events,
    this.showTimeLabels = true,
  });

  @override
  State<DayView> createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {
  List<DayData> dayData = List.generate(24, (hour) => DayData(hour));

  void expandDay(DayData data) {
    if (mounted) {
      setState(() {
        data.valueExpand = !data.isExpand;
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey[200],
            child: Center(
              child: Text(
                '${_weekdayLabel(widget.date.weekday)}\n${widget.date.day}/${widget.date.month}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Time slots
          Column(
            children: dayData.map((data) {
              final hourEvents = widget.events.where((event) => event.start.hour == data.hour).toList();
              if (hourEvents.length > 2 && !data.isExpand) {
                return Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ClickUtils(
                    onTap: (){
                      expandDay(data);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${hourEvents.length} events", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                        const Icon(Icons.expand, size: 16)
                      ],
                    ),
                  ),
                );
              }
              return Visibility(
                visible: hourEvents.length <= 2 || data.isExpand,
                child: Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: ClickUtils(
                    enable: hourEvents.length > 2,
                    onTap: (){
                      expandDay(data);
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: hourEvents.map((event) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 2),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.lightBlue.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              event.title,
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _weekdayLabel(int weekday) {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return labels[(weekday - 1) % 7];
  }
}
