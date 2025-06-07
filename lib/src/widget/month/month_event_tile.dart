import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/utils/time_utils.dart';

class MonthEventTile extends StatelessWidget {
  final String title;
  final DateTime start;
  final DateTime end;
  final TimeOfDay time;
  final bool isFirst;
  final bool isLast;

  const MonthEventTile({
    super.key,
    required this.title,
    required this.start,
    required this.end,
    required this.time,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            const SizedBox(width: 40), // space for timeline
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Text content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  TimeUtils.formatMonthYear(start ,format: "dd/MM/yyyy HH:mm"),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.flag, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  TimeUtils.formatMonthYear(end ,format: "dd/MM/yyyy HH:mm"),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Time
                    Row(
                      children: [
                        Text(
                          time.hourOfPeriod.toString().padLeft(2, '0'),
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Column(
                          children: [
                            Text(
                              ':${time.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              time.period == DayPeriod.am ? 'AM' : 'PM',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Dot + vertical timeline
        Positioned(
          left: 20,
          top: 0,
          bottom: 0,
          child: Column(
            children: [
              if (!isFirst)
                Expanded(
                  child: Container(width: 2, color: Colors.grey[300]),
                ),
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: Colors.grey[300]),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
