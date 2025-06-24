import 'package:flutter/material.dart';

class YearCalendarPicker extends StatefulWidget {
  const YearCalendarPicker({
    super.key,
    required this.initialYear,
    this.yearRange = 50,
  });

  final int initialYear;
  final int yearRange;

  @override
  State<YearCalendarPicker> createState() => _YearCalendarPickerState();
}

class _YearCalendarPickerState extends State<YearCalendarPicker> {
  late final List<int> years;
  final ScrollController _scrollController = ScrollController();
  final int crossAxisCount = 3;
  final double spacing = 8;
  final double itemHeight = 40; // 60 / 2 = 30 + spacing = 40

  @override
  void initState() {
    super.initState();

    final startYear = widget.initialYear - widget.yearRange;
    final endYear = widget.initialYear + widget.yearRange;
    years = List.generate(endYear - startYear + 1, (i) => startYear + i);

    // Delay scroll until layout is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedIndex = widget.yearRange;
      final rowIndex = (selectedIndex / crossAxisCount).floor();
      final targetScrollOffset = rowIndex * (itemHeight + spacing);

      _scrollController.jumpTo(targetScrollOffset - 150); // để selected nằm gần giữa
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedYear = widget.initialYear;

    return Container(
      width: 300,
      height: 400,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Year picker',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              itemCount: years.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final year = years[index];
                final isSelected = year == selectedYear;

                return GestureDetector(
                  onTap: () => Navigator.of(context).pop(year),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$year',
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
