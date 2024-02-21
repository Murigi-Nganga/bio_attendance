import 'package:flutter/material.dart';

class AppDropdownButton<T> extends StatelessWidget {
  const AppDropdownButton({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  final List<DropdownMenuItem<T>> items;
  final T value;
  final Function(T?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(40, 0, 0, 0)),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButton<T>(
        padding: const EdgeInsets.all(5.0),
        underline: const SizedBox(height: 0),
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        value: value,
        onChanged: onChanged,
        items: items,
      ),
    );
  }
}
