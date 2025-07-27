import 'package:flutter/material.dart';
import 'package:news_app/feutures/news_list/widgets/date_range_selector.dart';

class FilterAlertDialog extends StatefulWidget {
  const FilterAlertDialog({super.key});

  @override
  State<FilterAlertDialog> createState() => _FilterAlertDialogState();
}

class _FilterAlertDialogState extends State<FilterAlertDialog> {
  final TextEditingController _languageController = TextEditingController();

  DateTime? _from;
  DateTime? _to;

  void onCancel() {
    Navigator.pop(context);
  }

  void onConfirm() {
    final language = _languageController.text.trim();
    final Map<String, dynamic> params = {
      'language': language.isEmpty ? '' : language,
      'from': _from ?? '',
      'to': _to ?? '',
    };
    Navigator.of(context).pop(params);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Фильтры'),
      backgroundColor: Colors.white,
      content: SizedBox(
        height: 150,
        width: 900,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _languageController,
              maxLength: 2,
              decoration: InputDecoration(hintText: 'Язык например: RU'),
            ),
            DateRangeSelector(
              onRangeSelect: (range) {
                _from = range.start;
                _to = range.end;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text('Отмена', style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text('Применить', style: TextStyle(color: Color(0xff538AE4))),
        ),
      ],
    );
  }
}
