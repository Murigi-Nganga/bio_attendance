import 'package:bio_attendance/utilities/theme/sizes.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget{
  const AppButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
  });

  final VoidCallback onPressed;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: FontSize.small),
        ),
      ),
    );
  }
}
