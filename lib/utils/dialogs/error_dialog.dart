import 'package:flutter/material.dart';
import 'package:polaris_test/utils/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String content,
) {
  return showGenericDialog<void>(
    context: context,
    title: 'Error',
    content: content,
    optionBuilder: () => {'Ok': null},
  );
}
