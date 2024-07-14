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
            return _RadioGroupFormFieldContent(
              options: options,
              isMandatory: isMandatory,
              labelText: labelText,
              onFieldChanged: onFieldChanged,
              index: index,
              state: state,
            );
          },
        );

  @override
  FormFieldState<String> createState() => FormFieldState<String>();
}

class _RadioGroupFormFieldContent extends StatefulWidget {
  final FormFieldState<String> state;
  final List<String> options;
  final bool isMandatory;
  final int index;
  final String labelText;
  final Function(int, String, dynamic, String) onFieldChanged;
  const _RadioGroupFormFieldContent({
    required this.options,
    required this.isMandatory,
    required this.labelText,
    required this.onFieldChanged,
    required this.index,
    required this.state,
  });

  @override
  State<_RadioGroupFormFieldContent> createState() =>
      _RadioGroupFormFieldContentState();
}

class _RadioGroupFormFieldContentState
    extends State<_RadioGroupFormFieldContent>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return TextLabel(
      height: 5,
      labelText: widget.labelText,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ...widget.options.map(
          (option) => RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: widget.state.value,
            onChanged: (value) {
              widget.state.didChange(value);
              widget.onFieldChanged(
                widget.index,
                'selected_option',
                value,
                widget.labelText,
              );
            },
          ),
        ),
        if (widget.state.hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.state.errorText ?? '',
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ]),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
