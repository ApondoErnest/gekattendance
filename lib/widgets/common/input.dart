import 'package:flutter/material.dart';

class MyTextInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final String label;

  const MyTextInput(
      {super.key, required this.label, required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      style: Theme.of(context).textTheme.bodySmall,
      decoration: InputDecoration(
        isDense: true,
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        hintStyle: Theme.of(context).textTheme.bodyMedium,
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        // filled: true,
        // fillColor: Colors.white,
      ),
    );
  }
}
