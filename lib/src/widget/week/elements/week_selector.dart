import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LazyWeekSelector extends StatefulWidget {
  const LazyWeekSelector({
    super.key,
    required this.setSelectedWeek,
    required this.selectedDate,
  });

  final Function(DateTime startOfWeek, DateTime endOfWeek) setSelectedWeek;
  final DateTime selectedDate;

  @override
  State<LazyWeekSelector> createState() => _LazyWeekSelectorState();
}

class _LazyWeekSelectorState extends State<LazyWeekSelector> {
  final ScrollController _controller = ScrollController();
  final List<DateTime> _weeks = []; // each item is a Monday
  final int maxWeekCount = 13; // max number of weeks to show
  final double weekItemWidth = 140.0;
  final _dateFormat = DateFormat('dd/MM');

  @override
  void initState() {
    super.initState();
    _initWeeks();

    _controller.addListener(() {
      if (_controller.position.pixels >= _controller.position.maxScrollExtent - 100) {
        _addWeekToEnd();
      }

      if (_controller.position.pixels <= 100) {
        _addWeekToStart();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDateWeek();
    });
  }

  @override
  void didUpdateWidget(covariant LazyWeekSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isSameWeek(widget.selectedDate, oldWidget.selectedDate)) {
      _scrollToSelectedDateWeek();
    }
  }

  void _initWeeks() {
    final monday = _getMonday(widget.selectedDate);
    _weeks.add(monday.subtract(const Duration(days: 7)));
    _weeks.add(monday);
    _weeks.add(monday.add(const Duration(days: 7)));
  }

  DateTime _getMonday(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  bool _isSameWeek(DateTime a, DateTime b) {
    return _getMonday(a) == _getMonday(b);
  }

  void _scrollToSelectedDateWeek() {
    final monday = _getMonday(widget.selectedDate);

    if (!_weeks.contains(monday)) {
      setState(() {
        _weeks.clear();
        _weeks.add(monday.subtract(const Duration(days: 7)));
        _weeks.add(monday);
        _weeks.add(monday.add(const Duration(days: 7)));
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.jumpTo(weekItemWidth); // jump to middle
      });
    } else {
      final index = _weeks.indexOf(monday);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.animateTo(
          index * weekItemWidth,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _addWeekToEnd() {
    final nextWeek = _weeks.last.add(const Duration(days: 7));
    if (!_weeks.contains(nextWeek)) {
      setState(() {
        _weeks.add(nextWeek);
        if (_weeks.length > maxWeekCount) {
          _weeks.removeAt(0);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _controller.jumpTo(_controller.position.pixels - weekItemWidth);
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
          _controller.jumpTo(_controller.position.pixels + weekItemWidth);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        itemCount: _weeks.length,
        itemBuilder: (context, index) {
          final monday = _weeks[index];
          final sunday = monday.add(const Duration(days: 6));
          final isSelected = _isSameWeek(monday, widget.selectedDate);

          return GestureDetector(
            onTap: () {
              widget.setSelectedWeek(monday, sunday);
            },
            child: Container(
              width: weekItemWidth - 10,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Center(
                child: Text(
                  '${_dateFormat.format(monday)} - ${_dateFormat.format(sunday)}',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
