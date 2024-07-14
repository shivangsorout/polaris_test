import 'package:flutter/material.dart';
import 'package:polaris_test/helpers/custom_widgets/text_label.dart';

class CheckboxesFormField extends FormField<List<String>> {
  final int index;
  final List<String> options;
  final bool isMandatory;
  final String labelText;
  final Function(int, String, dynamic, String) onFieldChanged;

  CheckboxesFormField({
    super.key,
    required this.index,
    required this.options,
    required this.isMandatory,
    required this.labelText,
    required this.onFieldChanged,
  }) : super(
          onSaved: (_) {},
          validator: (value) {
            if (isMandatory && (value == null || value.isEmpty)) {
              return 'Please select atleast one option!';
            } else {
              return null;
            }
          },
          builder: (FormFieldState<List<String>> state) {
            return TextLabel(
              height: 5,
              labelText: labelText,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: options
                        .asMap()
                        .entries
                        .map(
                          (entry) => CheckboxListTile(
                            title: Text(entry.value),
                            value: state.value?.contains(entry.value) ?? false,
                            onChanged: (bool? isChecked) {
                              final List<String> newValue =
                                  List<String>.from(state.value ?? []);
                              if (isChecked == true) {
                                newValue.add(entry.value);
                              } else {
                                newValue.remove(entry.value);
                              }
                              onFieldChanged(
                                index,
                                'selected_options',
                                newValue,
                                labelText,
                              );
                              state.didChange(newValue);
                            },
                          ),
                        )
                        .toList(),
                  ),
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        state.errorText ?? '',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            );
          },
        );
}
