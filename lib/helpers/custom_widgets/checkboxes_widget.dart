import 'package:flutter/material.dart';
import 'package:polaris_test/helpers/custom_widgets/text_label.dart';

class CheckboxesWidget extends StatefulWidget {
  final int index;
  final List<String> options;
  final bool isMandatory;
  final String labelText;
  final Function(int, String, dynamic, String) onFieldChanged;

  const CheckboxesWidget({
    super.key,
    required this.index,
    required this.options,
    required this.isMandatory,
    required this.labelText,
    required this.onFieldChanged,
  });

  @override
  State<CheckboxesWidget> createState() => _CheckboxesWidgetState();
}

class _CheckboxesWidgetState extends State<CheckboxesWidget> {
  late List<bool> _isChecked;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _isChecked = List<bool>.filled(widget.options.length, false);
  }

  void _onCheckboxChanged(int index, bool? value) {
    setState(() {
      _isChecked[index] = value ?? false;
      _validate();
      _notifyParent();
    });
  }

  void _validate() {
    if (widget.isMandatory && !_isChecked.contains(true)) {
      setState(() {
        _hasError = true;
      });
    } else {
      setState(() {
        _hasError = false;
      });
    }
  }

  void _notifyParent() {
    final selectedOptions = widget.options
        .asMap()
        .entries
        .where((entry) => _isChecked[entry.key])
        .map((entry) => entry.value)
        .toList();
    widget.onFieldChanged(
      widget.index,
      'selected_options',
      selectedOptions,
      widget.labelText,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextLabel(
      height: 5,
      labelText: widget.labelText,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(widget.options.length, (index) {
            return CheckboxListTile(
              title: Text(widget.options[index]),
              value: _isChecked[index],
              onChanged: (value) => _onCheckboxChanged(index, value),
            );
          }),
          if (_hasError)
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'At least one option must be selected.',
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
