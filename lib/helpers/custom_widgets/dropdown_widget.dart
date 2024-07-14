import 'package:flutter/material.dart';
import 'package:polaris_test/utils/constant.dart';

class DropdownWidgetFormField extends StatefulWidget {
  final String labelText;
  final List<String> options;
  final int index;
  final bool isMandatory;
  final Function(int, String, dynamic, String) onFieldChanged;

  const DropdownWidgetFormField({
    super.key,
    required this.labelText,
    required this.options,
    required this.index,
    required this.isMandatory,
    required this.onFieldChanged,
  });

  @override
  State<DropdownWidgetFormField> createState() =>
      _DropdownWidgetFormFieldState();
}

class _DropdownWidgetFormFieldState extends State<DropdownWidgetFormField> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      hint: const Text('Select appropriate option'),
      items: widget.options
          .map((option) => DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              ))
          .toList(),
      onChanged: (newValue) {
        widget.onFieldChanged(
          widget.index,
          'selected_option',
          newValue,
          widget.labelText,
        );
      },
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: const TextStyle(fontSize: 20),
        border: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
      ),
      validator: (value) {
        if (widget.isMandatory && (value == null || value.isEmpty)) {
          return 'This field is required. Please enter something';
        }
        return null;
      },
    );
  }
}
