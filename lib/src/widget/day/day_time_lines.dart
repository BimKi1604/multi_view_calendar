import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/data/data.dart';

class DayTimeLines extends StatelessWidget {
  const DayTimeLines({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: List.generate(24, (index) {
          return Container(
            height: DataApp.heightEvent,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade300, width: 0.5),
              ),
            ),
          );
        }),
      ),
    );
  }
}
