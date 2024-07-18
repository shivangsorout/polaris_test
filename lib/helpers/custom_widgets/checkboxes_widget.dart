import 'package:flutter/material.dart';
import 'package:polaris_test/helpers/custom_widgets/text_label.dart';
import 'package:polaris_test/models/form_field.dart';
import 'package:polaris_test/models/meta_info/checkbox_meta_info.dart';

class CheckboxesFormField extends FormField<List<String>> {
  final int index;
  final bool isMandatory;
  final FormFieldData formField;
  final Function(int, FormFieldData) onFieldChanged;

  CheckboxesFormField({
    super.key,
    required this.index,
    required this.isMandatory,
    required this.formField,
    required this.onFieldChanged,
  }) : super(
          initialValue:
              (formField.metaInfo as CheckboxMetaInfo).selectedOptions,
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
              isMandatory: isMandatory,
              formField: formField,
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
  final bool isMandatory;
  final FormFieldData formField;
  final Function(int, FormFieldData) onFieldChanged;

  const _CheckboxesFormFieldContent({
    required this.state,
    required this.index,
    required this.isMandatory,
    required this.formField,
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
    final metaInfo = widget.formField.metaInfo as CheckboxMetaInfo;
    return TextLabel(
      height: 5,
      labelText: metaInfo.label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            children: metaInfo.options
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
                      final updatedMetaInfo = CheckboxMetaInfo(
                        label: metaInfo.label,
                        isMandatory: metaInfo.isMandatory,
                        options: metaInfo.options,
                        selectedOptions: newValue,
                      );
                      final updatedFormField = FormFieldData(
                        metaInfo: updatedMetaInfo,
                        componentType: widget.formField.componentType,
                      );
                      widget.onFieldChanged(
                        widget.index,
                        updatedFormField,
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
