import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/widget/year/year_view_state.dart';

class YearView extends StatefulWidget {
  final int year;

  const YearView({super.key, required this.year});

  @override
  State<YearView> createState() => YearViewState();
}

