import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/data/data.dart';

class TimeColumn extends StatelessWidget {
  const TimeColumn({super.key});

  @override
  Widget build(BuildContext context) {
    final hours = List.generate(24, (index) => index);
    return Container(
      width: DataApp.widthTimeColumn,
      padding: const EdgeInsets.only(right: 10.0),
      decoration: BoxDecoration(
          border: Border(
              right: BorderSide(
        color: DataApp.borderColor,
      ))),
      child: Column(
        children: hours.map((hour) {
          return SizedBox(
            height: DataApp.heightEvent,
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                '${hour.toString().padLeft(2, '0')}:00',
                style: TextStyle(
                    fontSize: 12,
                    color: DataApp.mainColor,
                    fontWeight: FontWeight.w900),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
