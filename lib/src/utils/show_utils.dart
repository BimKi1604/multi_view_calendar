import 'dart:math';

import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/data/data.dart';
import 'package:multi_view_calendar/src/models/calendar_event.dart';
import 'package:multi_view_calendar/src/utils/time_utils.dart';
import 'package:multi_view_calendar/src/widget/elements/pretty_month_picker.dart';

/// class helper for show widget
class ShowUtils {

  static Widget eventWidget({required Widget child, double? size}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(width: 1.5, color: DataApp.iconColor)
      ),
      width: size ?? 21,
      alignment: Alignment.center,
      child: child,
    );
  }

  static void tooltipSingleEvent(BuildContext context, CalendarEvent event, Color color) {
    final text = 'From: ${event.start.hour}:${event.start.minute.toString().padLeft(2, '0')}\n'
        'To: ${event.end.hour}:${event.end.minute.toString().padLeft(2, '0')}';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: color,
        title: Text(event.title, style: const TextStyle(color: Colors.white),),
        content: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  static void tooltipMulEvent(BuildContext context, List<CalendarEvent> events, Color color) {
    List<Widget> content = [];
    for (final event in events) {
      final text = 'From: ${event.start.hour}:${event.start.minute.toString().padLeft(2, '0')}\n'
          'To: ${event.end.hour}:${event.end.minute.toString().padLeft(2, '0')}';
      content = [...content, Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5.0),
          Text(event.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 5.0),
          Text(text, style: const TextStyle(fontSize: 12, color: Colors.white)),
        ],
      )];
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: color,
        title: const Text("Events", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: content,
        ),
      ),
    );
  }

  static void showSingleEventDetails(BuildContext context, CalendarEvent event, Color color) {
    showModalBottomSheet(
      backgroundColor: color,
      context: context,
      builder: (_) => Padding(
          padding: const EdgeInsets.all(16),
          child: _detailEvent(event, paddingBottom: false)
      ),
    );
  }

  static Widget _detailEvent(CalendarEvent event, {bool paddingBottom = true}) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(event.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      const SizedBox(height: 8),
      Text('Start: ${event.start}', style: const TextStyle(color: Colors.white)),
      Text('End: ${event.end}', style: const TextStyle(color: Colors.white)),
      Visibility(
          visible: paddingBottom,
          child: const SizedBox(height: 10.0)
      )
    ],
  );

  static void showEventsDetails(BuildContext context, List<CalendarEvent> events, Color color) {
    showModalBottomSheet(
      backgroundColor: color,
      context: context,
      builder: (_) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: events.map((event) =>  _detailEvent(event, paddingBottom: event == events.last ? false : true )).toList(),
          )
      ),
    );
  }

  static Future<DateTime?> showDialogWidget({
    required BuildContext context,
    required Widget child,
  }) async {
    return showDialog<DateTime>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: child,
        );
      },
    );
  }

  static void showFullScreenDialog(BuildContext context, {required Widget child}) {
    showGeneralDialog(
      context: context,
      barrierLabel: "FullScreenDialog",
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return child;
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(CurvedAnimation(
            parent: anim,
            curve: Curves.easeOutCubic,
          )),
          child: child,
        );
      },
    );
  }
}