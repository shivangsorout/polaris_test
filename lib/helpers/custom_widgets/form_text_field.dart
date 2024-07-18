import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polaris_test/models/form_field.dart';
import 'package:polaris_test/models/meta_info/edit_text_meta_info.dart';
import 'package:polaris_test/utils/constant.dart';

class FormTextField extends StatefulWidget {
  const FormTextField({
    super.key,
    this.maxLines = 1,
    required this.formField,
    required this.onFieldChanged,
    required this.index,
  });

  final FormFieldData formField;
  final int? maxLines;
  final int index;
  final Function(int, FormFieldData) onFieldChanged;

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField>
    with AutomaticKeepAliveClientMixin {
  late final TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    final metaInfo = widget.formField.metaInfo as EditTextMetaInfo;
    _textController.text = metaInfo.filledInput;
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final metaInfo = widget.formField.metaInfo as EditTextMetaInfo;
    bool isInteger = metaInfo.componentInputType == 'INTEGER';
    return TextFormField(
      keyboardType: isInteger ? TextInputType.number : TextInputType.name,
      inputFormatters: [
        if (isInteger) FilteringTextInputFormatter.digitsOnly,
      ],
      controller: _textController,
      validator: (value) {
        if (metaInfo.isMandatory && (value == null || value.isEmpty)) {
          return 'This field can\'t be empty. Please enter something!';
        } else {
          return null;
        }
      },
      onChanged: (value) {
        final updatedMetaInfo = EditTextMetaInfo(
          componentInputType: metaInfo.componentInputType,
          label: metaInfo.label,
          isMandatory: metaInfo.isMandatory,
          filledInput: value,
        );
        final updatedFormField = FormFieldData(
          metaInfo: updatedMetaInfo,
          componentType: widget.formField.componentType,
        );
        widget.onFieldChanged(widget.index, updatedFormField);
      },
      textInputAction: TextInputAction.next,
      maxLines: widget.maxLines,
      minLines: 1,
      decoration: InputDecoration(
        enabled: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: metaInfo.label,
        labelStyle: const TextStyle(fontSize: 20),
        hintText: 'Enter ${metaInfo.label}',
        border: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
