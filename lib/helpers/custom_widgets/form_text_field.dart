import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polaris_test/utils/constant.dart';

class FormTextField extends StatefulWidget {
  const FormTextField({
    super.key,
    this.maxLines = 1,
    required this.labelText,
    required this.inputType,
    required this.isMandatory,
    required this.onFieldChanged,
    required this.index,
  });

  final String labelText;
  final int? maxLines;
  final String inputType;
  final bool isMandatory;
  final int index;
  final Function(int, String, dynamic, String) onFieldChanged;

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isInteger = widget.inputType == 'INTEGER';
    return TextFormField(
      keyboardType: isInteger ? TextInputType.number : TextInputType.name,
      inputFormatters: [
        if (isInteger) FilteringTextInputFormatter.digitsOnly,
      ],
      controller: _textController,
      validator: (value) {
        if (widget.isMandatory && (value == null || value.isEmpty)) {
          return 'This field can\'t be empty. Please enter something!';
        } else {
          return null;
        }
      },
      onChanged: (value) {
        widget.onFieldChanged(widget.index, 'value', value, widget.labelText);
      },
      textInputAction: TextInputAction.next,
      maxLines: widget.maxLines,
      minLines: 1,
      decoration: InputDecoration(
        enabled: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: widget.labelText,
        labelStyle: const TextStyle(fontSize: 20),
        hintText: 'Enter ${widget.labelText}',
        border: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
      ),
    );
  }
}
