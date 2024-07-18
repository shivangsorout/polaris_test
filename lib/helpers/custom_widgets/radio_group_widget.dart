import 'package:flutter/material.dart';
import 'package:polaris_test/helpers/custom_widgets/text_label.dart';
import 'package:polaris_test/models/form_field.dart';
import 'package:polaris_test/models/meta_info/radio_group_meta_info.dart';

class RadioGroupFormField extends FormField<String> {
  final bool isMandatory;
  final FormFieldData formField;
  final int index;
  final Function(int, FormFieldData) onFieldChanged;

  RadioGroupFormField({
    super.key,
    required this.isMandatory,
    required this.formField,
    required this.onFieldChanged,
    required this.index,
  }) : super(
          initialValue:
              (formField.metaInfo as RadioGroupMetaInfo).selectedOption,
          validator: (value) {
            if (isMandatory && (value == null || value.isEmpty)) {
              return 'Please select an option!';
            } else {
              return null;
            }
          },
          builder: (FormFieldState<String> state) {
            return _RadioGroupFormFieldContent(
              isMandatory: isMandatory,
              formField: formField,
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
  final bool isMandatory;
  final FormFieldData formField;
  final int index;
  final Function(int, FormFieldData) onFieldChanged;
  const _RadioGroupFormFieldContent({
    required this.isMandatory,
    required this.formField,
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
    final metaInfo = widget.formField.metaInfo as RadioGroupMetaInfo;
    return TextLabel(
      height: 5,
      labelText: metaInfo.label,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ...metaInfo.options.map(
          (option) => RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: widget.state.value,
            onChanged: (value) {
              widget.state.didChange(value);
              final updatedMetaInfo = RadioGroupMetaInfo(
                options: metaInfo.options,
                label: metaInfo.label,
                isMandatory: metaInfo.isMandatory,
                selectedOption: value ?? '',
              );
              final updatedFormField = FormFieldData(
                metaInfo: updatedMetaInfo,
                componentType: widget.formField.componentType,
              );
              widget.onFieldChanged(
                widget.index,
                updatedFormField,
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
