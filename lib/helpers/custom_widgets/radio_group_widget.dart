import 'package:flutter/material.dart';
import 'package:polaris_test/helpers/custom_widgets/text_label.dart';

class RadioGroupFormField extends FormField<String> {
  final List<String> options;
  final bool isMandatory;
  final int index;
  final String labelText;
  final Function(int, String, dynamic, String) onFieldChanged;

  RadioGroupFormField({
    super.key,
    required this.options,
    required this.isMandatory,
    required this.labelText,
    required this.onFieldChanged,
    required this.index,
  }) : super(
          // onSaved: onSaved,
          validator: (value) {
            if (isMandatory && (value == null || value.isEmpty)) {
              return 'Please select an option!';
            } else {
              return null;
            }
          },
          builder: (FormFieldState<String> state) {
            return TextLabel(
              height: 5,
              labelText: labelText,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...options.map(
                      (option) => RadioListTile<String>(
                        title: Text(option),
                        value: option,
                        groupValue: state.value,
                        onChanged: (value) {
                          state.didChange(value);
                          onFieldChanged(
                            index,
                            'selected_option',
                            value,
                            labelText,
                          );
                        },
                      ),
                    ),
                    if (state.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          state.errorText ?? '',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ]),
            );
          },
        );

  @override
  FormFieldState<String> createState() => _CustomRadioGroupFormFieldState();
}

class _CustomRadioGroupFormFieldState extends FormFieldState<String> {}
