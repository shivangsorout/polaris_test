import 'package:flutter/material.dart';
import 'package:polaris_test/utils/dialogs/generic_dialog.dart';

Future<void> showSuccessDialog(
  BuildContext context,
  String content,
) {
  return showGenericDialog<void>(
    context: context,
    title: 'Success',
    content: content,
    optionBuilder: () => {'Ok': null},
  );
}