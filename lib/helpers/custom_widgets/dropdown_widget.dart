import 'package:flutter/material.dart';
import 'package:polaris_test/models/form_field.dart';
import 'package:polaris_test/models/meta_info/dropdown_meta_info.dart';
import 'package:polaris_test/utils/constant.dart';

class DropdownWidgetFormField extends StatefulWidget {
  final int index;
  final FormFieldData formField;
  final Function(int, FormFieldData) onFieldChanged;

  const DropdownWidgetFormField({
    super.key,
    required this.index,
    required this.formField,
    required this.onFieldChanged,
  });

  @override
  State<DropdownWidgetFormField> createState() =>
      _DropdownWidgetFormFieldState();
}

class _DropdownWidgetFormFieldState extends State<DropdownWidgetFormField>
    with AutomaticKeepAliveClientMixin {
  String? selectedValue;

  @override
  void initState() {
    final metaInfo = widget.formField.metaInfo as DropdownMetaInfo;
    if (metaInfo.selectedOption.isNotEmpty) {
      setState(() {
        selectedValue = metaInfo.selectedOption;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final metaInfo = widget.formField.metaInfo as DropdownMetaInfo;
    return DropdownButtonFormField<String>(
      hint: const Text('Select appropriate option'),
      items: metaInfo.options
          .map((option) => DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              ))
          .toList(),
      value: selectedValue,
      onChanged: (newValue) {
        setState(() {
          selectedValue = newValue;
        });
        final updatedMetaInfo = DropdownMetaInfo(
          label: metaInfo.label,
          isMandatory: metaInfo.isMandatory,
          options: metaInfo.options,
          selectedOption: selectedValue ?? '',
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
      decoration: InputDecoration(
        labelText: metaInfo.label,
        labelStyle: const TextStyle(fontSize: 20),
        border: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
      ),
      validator: (value) {
        if (metaInfo.isMandatory && (value == null || value.isEmpty)) {
          return 'This field is required. Please enter something';
        }
        return null;
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
