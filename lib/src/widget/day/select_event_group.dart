import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_view_calendar/src/models/calendar_event.dart';

class SelectEventGroup extends StatelessWidget {
  const SelectEventGroup({super.key, required this.events});

  final List<CalendarEvent> events;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select event',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: events.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final event = events[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 3),
                  leading: const Icon(Icons.event_note, color: Colors.blueAccent),
                  title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('dd MMMM, yyyy').format(event.start),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      if (event.description != null && event.description!.isNotEmpty)
                        Text(
                          event.description!,
                          style: const TextStyle(fontSize: 13, color: Colors.black87),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                  onTap: () => Navigator.of(context).pop(event),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
