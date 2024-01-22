import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<bool> showConfirmDialog(BuildContext context, String text) async {
  final result = await showGenericDialog<bool>(
    context: context,
    title: 'Confirm',
    content: text,
    optionsBuilder: () => {
      'Yes': true,
      'No': false,
    },
  );

  return result ?? false;

}