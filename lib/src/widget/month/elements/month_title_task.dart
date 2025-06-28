import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/data/data.dart';
import 'package:multi_view_calendar/src/utils/click_utils.dart';

class MonthTitleTask extends StatelessWidget {
  final String title;
  final VoidCallback onAdd;

  const MonthTitleTask({
    super.key,
    this.title = "Today's Task",
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Divider(
              color: Colors.grey.shade400,
              thickness: 1,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: DataApp.mainColor,
              shape: BoxShape.circle,
            ),
            child: ClickUtils(
              onTap: onAdd,
              borderRadius: BorderRadius.circular(100),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
