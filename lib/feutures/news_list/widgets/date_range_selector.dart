import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeSelector extends StatefulWidget {
  final void Function(DateTimeRange) onRangeSelect;
  const DateRangeSelector({super.key, required this.onRangeSelect});

  @override
  State<DateRangeSelector> createState() => _DateRangeSelectorState();
}

class _DateRangeSelectorState extends State<DateRangeSelector> {
  DateTimeRange? _selectedDateRange;
  final _formatter = DateFormat('yyyy-MM-dd');

  Future<void> _pickDateRange() async {
    final DateTime now = DateTime.now();
    final DateTimeRange? pickedDate = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 10),
      lastDate: now,
      helpText: 'Выберите даты',
      cancelText: 'Отмена',
      confirmText: 'Выбрать',
      initialDateRange:
          _selectedDateRange ?? DateTimeRange(start: now, end: now),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDateRange = pickedDate;
      });
      widget.onRangeSelect(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rangeText = _selectedDateRange == null
        ? 'Даты не выбранные'
        : 'C ${_formatter.format(_selectedDateRange!.start)} до ${_formatter.format(_selectedDateRange!.end)}';

    return Column(
      children: [
        Text(rangeText),
        SizedBox(height: 5),
        ElevatedButton(onPressed: _pickDateRange, child: Text('Выбрать дату')),
      ],
    );
  }
}
