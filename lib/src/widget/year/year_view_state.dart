
import 'package:flutter/material.dart';
import 'package:multi_view_calendar/src/utils/click_utils.dart';
import 'package:multi_view_calendar/src/utils/show_utils.dart';
import 'package:multi_view_calendar/src/widget/year/elements/mini_month.dart';
import 'package:multi_view_calendar/src/widget/year/elements/year_picker.dart';
import 'package:multi_view_calendar/src/widget/year/year_view.dart';

class YearViewState extends State<YearView> {
  late int _selectedYear;

  @override
  void initState() {
    _selectedYear = widget.year;

    super.initState();
  }

  void _setYear(int year) {
    if (!mounted) return;
    _selectedYear = year;
    setState(() {

    });
  }

  void _pickYear() async {
    int? year = await ShowUtils.showDialogWidget(
        context: context,
        child: YearCalendarPicker(
          initialYear: _selectedYear,
        )
    );
    if (year == null) return;
    _setYear(year);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15.0,),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ClickUtils(
              onTap: () async {
                _pickYear();
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Year: $_selectedYear",
                      style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 2.0),
                    const Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey,)
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 5.0,),
          GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: 12,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                return RepaintBoundary(
                    child: MiniMonth(
                        key: ValueKey("$_selectedYear${index+1}"),
                        year: _selectedYear, month: index + 1
                    )
                );
              }
          ),
        ],
      ),
    );
  }
}
