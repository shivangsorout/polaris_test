import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polaris_test/utils/constant.dart';

class FormTextField extends StatelessWidget {
  const FormTextField({
    super.key,
    required TextEditingController textController,
    this.maxLines = 1,
    required this.labelText,
    required this.inputType,
    required this.isMandatory,
  }) : _titleController = textController;

  final TextEditingController _titleController;
  final String labelText;
  final int? maxLines;
  final String inputType;
  final bool isMandatory;

  @override
  Widget build(BuildContext context) {
    bool isInteger = inputType == 'INTEGER';
    return TextFormField(
      keyboardType: isInteger ? TextInputType.number : TextInputType.name,
      inputFormatters: [
        if (isInteger) FilteringTextInputFormatter.digitsOnly,
      ],
      controller: _titleController,
      validator: (value) {
        if (isMandatory) {
          if (value == null || value.isEmpty) {
            return 'This field can\'t be empty. Please enter something!';
          } else {
            return null;
          }
        } else {
          return null;
        }
      },
      textInputAction: TextInputAction.next,
      maxLines: maxLines,
      minLines: 1,
      decoration: InputDecoration(
        enabled: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: labelText,
        labelStyle: const TextStyle(fontSize: 20),
        hintText: 'Enter $labelText',
        border: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
      ),
    );
  }
}
