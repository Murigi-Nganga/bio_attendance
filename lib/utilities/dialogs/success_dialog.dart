import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<void> showSuccessDialog(BuildContext context, String text) {
  return showGenericDialog<void>(
    context: context,
    title: 'Success',
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}