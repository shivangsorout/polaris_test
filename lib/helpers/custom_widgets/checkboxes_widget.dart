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
            return _CheckboxesFormFieldContent(
              state: state,
              index: index,
              options: options,
              isMandatory: isMandatory,
              labelText: labelText,
              onFieldChanged: onFieldChanged,
            );
          },
        );
  @override
  FormFieldState<List<String>> createState() => FormFieldState<List<String>>();
}

class _CheckboxesFormFieldContent extends StatefulWidget {
  final FormFieldState<List<String>> state;
  final int index;
  final List<String> options;
  final bool isMandatory;
  final String labelText;
  final Function(int, String, dynamic, String) onFieldChanged;

  const _CheckboxesFormFieldContent({
    required this.state,
    required this.index,
    required this.options,
    required this.isMandatory,
    required this.labelText,
    required this.onFieldChanged,
  });

  @override
  State<_CheckboxesFormFieldContent> createState() =>
      _CheckboxesFormFieldContentState();
}

class _CheckboxesFormFieldContentState
    extends State<_CheckboxesFormFieldContent>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return TextLabel(
      height: 5,
      labelText: widget.labelText,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            children: widget.options
                .asMap()
                .entries
                .map(
                  (entry) => CheckboxListTile(
                    title: Text(entry.value),
                    value: widget.state.value?.contains(entry.value) ?? false,
                    onChanged: (bool? isChecked) {
                      final List<String> newValue =
                          List<String>.from(widget.state.value ?? []);
                      if (isChecked == true) {
                        newValue.add(entry.value);
                      } else {
                        newValue.remove(entry.value);
                      }
                      widget.onFieldChanged(
                        widget.index,
                        'selected_options',
                        newValue,
                        widget.labelText,
                      );
                      widget.state.didChange(newValue);
                    },
                  ),
                )
                .toList(),
          ),
          if (widget.state.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                widget.state.errorText ?? '',
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
