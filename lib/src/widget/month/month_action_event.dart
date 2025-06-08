import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/component/button_default.dart';
import 'package:multi_view_calendar/src/data/calendar_view_type.dart';
import 'package:multi_view_calendar/src/models/calendar_event.dart';
import 'package:multi_view_calendar/src/utils/click_utils.dart';
import 'package:multi_view_calendar/src/utils/string_utils.dart';
import 'package:multi_view_calendar/src/utils/time_utils.dart';

class MonthActionEvent extends StatefulWidget {
  const MonthActionEvent({super.key});

  @override
  State<MonthActionEvent> createState() => _MonthActionEventState();
}

class _MonthActionEventState extends State<MonthActionEvent> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final FocusNode locationFocusNode = FocusNode();

  String alphabet = "";
  DateTime? startDate;
  DateTime? endDate;
  Color? randomColor;

  final colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.red,
  ];

  final rand = Random();

  @override
  void initState() {
    randomColor = colors[rand.nextInt(colors.length)];
    locationFocusNode.addListener(() {
      if (!locationFocusNode.hasFocus) {
        if (mounted) setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    locationFocusNode.dispose();
    super.dispose();
  }

  void onChangeTitle(String value) {
    if (value.isEmpty) {
      alphabet = "";
      setState(() {});
      return;
    }
    if (value.length > 1) {
      return;
    }
    alphabet = value[0].toUpperCase();
    setState(() {});
  }

  void _onSubmit() {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }
    if (startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start and end date')),
      );
      return;
    }

    // Create new event
    CalendarEvent newEvent = CalendarEvent(
      id: TimeUtils.generateSimpleId(),
      title: titleController.text,
      color: randomColor!,
      start: startDate!,
      end: endDate!,
      description: descriptionController.text,
      location: locationController.text,
    );


    Navigator.pop(context);

  }

  Widget iconByType() {
    MeetingPlatform platform = StringUtils.detectMeetingPlatform(locationController.text);
    String rootImg = "assets/icons/";
    switch (platform) {
      case MeetingPlatform.zoom:
        rootImg += "zoom.png";
        return Image.asset(rootImg);
      case MeetingPlatform.googleMeet:
        rootImg += "google_meet.png";
        return Image.asset(rootImg);
      case MeetingPlatform.skype:
        rootImg += "skype.png";
        return Image.asset(rootImg);
      case MeetingPlatform.teams:
        rootImg += "teams.png";
        return Image.asset(rootImg);
      default:
        return const Icon(Icons.location_on, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(15),
            height: size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      ClickUtils(
                          borderRadius: BorderRadius.circular(25.0),
                          onTap: (){
                            Navigator.pop(context);
                          }, child: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: BackButtonIcon(),
                      )
                      ),
                      const Spacer(),
                      ButtonDefault(
                        onTap: (){
                          _onSubmit();
                        },
                        child: const Text("Save", style: TextStyle(color: Colors.white, fontSize: 16),),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Title
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue.shade100,
                          child: Text(alphabet, style: const TextStyle(fontSize: 20, color: Colors.black87),),
                        ),
                      ),
                      Expanded(
                          child: _buildContentGroup(title: "Title", content: TextField(
                            onChanged: (value) {
                              onChangeTitle(value);
                            },
                            controller: titleController,
                            style: const TextStyle(fontSize: 13, color: Colors.black),
                            maxLines: 1,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                          ),)
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildContentGroup(
                    title: "Description",
                    content: TextField(
                      controller: descriptionController,
                      style: const TextStyle(fontSize: 13, color: Colors.black),
                      maxLines: 1,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  // Start Date
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('From'),
                    subtitle: Text(startDate != null
                        ? startDate.toString()
                        : 'Empty'),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final picked = await TimeUtils.showDateTimePicker(context, startDate);
                      if (picked != null) {
                        setState(() => startDate = picked);
                      }
                    },
                  ),

                  // End Date
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('To'),
                    subtitle: Text(endDate != null
                        ? endDate.toString()
                        : 'Empty'),
                    trailing: const Icon(Icons.flag),
                    onTap: () async {
                      final picked = await TimeUtils.showDateTimePicker(context, endDate);
                      if (picked != null) {
                        setState(() => endDate = picked);
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  _buildContentGroup(
                    title: "Location",
                    content: TextField(

                      controller: locationController,
                      style: const TextStyle(fontSize: 13, color: Colors.black),
                      maxLines: 1,
                      focusNode: locationFocusNode,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                          child: iconByType(),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          maxWidth: 30,
                          maxHeight: 30,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                        isDense: true,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}

Widget _buildContentGroup({required String title, required Widget content}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500 , color: Colors.grey.shade400)),
      const SizedBox(height: 8.0),
      content
    ],
  );
}