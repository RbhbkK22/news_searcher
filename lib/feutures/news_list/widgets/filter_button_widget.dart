import 'package:flutter/material.dart';

class FilterButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const FilterButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: onPressed,
          child: Text("Фильтры", style: TextStyle(color: Color(0xff538AE4))),
        ),
      ],
    );
  }
}
