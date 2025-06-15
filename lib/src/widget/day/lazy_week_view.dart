import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/utils/time_utils.dart';
import 'package:multi_view_calendar/src/widget/day/lazy_week_element.dart';

class LazyWeekView extends StatefulWidget {
  const LazyWeekView({super.key, required this.setSelected, required this.selectedDate});

  final Function(DateTime) setSelected;
  final DateTime selectedDate;

  @override
  State<LazyWeekView> createState() => _LazyWeekViewState();
}

class _LazyWeekViewState extends State<LazyWeekView> {
  final ScrollController _controller = ScrollController();
  final List<DateTime> _weeks = [];
  final int maxWeekCount = 7;
  final double weekWidth = 56 * 7 + 14; // 56/day + margin

  @override
  void initState() {
    super.initState();
    _initWeeks();

    _controller.addListener(() {
      // Scroll to right → load next week
      if (_controller.position.pixels >= _controller.position.maxScrollExtent - 100) {
        _addWeekToEnd();
      }

      // Scroll to left → load previous week
      if (_controller.position.pixels <= 100) {
        _addWeekToStart();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LazyWeekView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!TimeUtils.isSameWeek(widget.selectedDate, oldWidget.selectedDate)) {
      _scrollToSelectedDateWeek();
    }
  }

  void _scrollToSelectedDateWeek() {
    final monday = widget.selectedDate.subtract(Duration(days: widget.selectedDate.weekday - 1));

    /// if weeks don't contain week => add middle
    if (!_weeks.contains(monday)) {
      setState(() {
        _weeks.clear();
        _weeks.add(monday.subtract(const Duration(days: 7))); /// prev week
        _weeks.add(monday); /// present week
        _weeks.add(monday.add(const Duration(days: 7))); /// next week
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.jumpTo(weekWidth); /// jump to middle week
      });
    } else { /// contain week
      final index = _weeks.indexOf(monday);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.animateTo(
          index * weekWidth,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _initWeeks() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    _weeks.add(monday);
  }

  void _addWeekToEnd() {
    final nextWeek = _weeks.last.add(const Duration(days: 7));
    if (!_weeks.contains(nextWeek)) {
      setState(() {
        _weeks.add(nextWeek);
        if (_weeks.length > maxWeekCount) {
          _weeks.removeAt(0);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _controller.jumpTo(_controller.position.pixels - weekWidth);
          });
        }
      });
    }
  }

  void _addWeekToStart() {
    final prevWeek = _weeks.first.subtract(const Duration(days: 7));
    if (!_weeks.contains(prevWeek)) {
      setState(() {
        _weeks.insert(0, prevWeek);
        if (_weeks.length > maxWeekCount) {
          _weeks.removeLast();
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _controller.jumpTo(_controller.position.pixels + weekWidth);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        controller: _controller,
        scrollDirection: Axis.horizontal,
        itemCount: _weeks.length,
        itemBuilder: (context, index) {
          return LazyWeekElement(
            weekStart: _weeks[index],
            selectedDate: widget.selectedDate,
            setSelected: (date) {
              widget.setSelected(date);
            },
          );
        },
      ),
    );
  }
}
