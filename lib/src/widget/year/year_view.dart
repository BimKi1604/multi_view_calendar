import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'year_view_state.dart';

class YearView extends StatefulWidget {
  final int year;

  const YearView({super.key, required this.year});

  @override
  State<YearView> createState() => YearViewState();
}

