import 'package:flutter/material.dart';
import 'package:polaris_test/helpers/custom_widgets/checkboxes_widget.dart';
import 'package:polaris_test/utils/keys_constant.dart';
// import 'package:polaris_test/helpers/custom_widgets/text_label.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Map<int, Map<String, dynamic>> _formResponses = {};

  void _onFieldChanged(
    int index,
    String key,
    dynamic value,
    String label,
  ) {
    setState(() {
      if (!_formResponses.containsKey(index)) {
        _formResponses[index] = {};
      }
      _formResponses[index]![key] = value;
      _formResponses[index]![keyLabel] = label;
    });
    print(_formResponses);
  }

  List<Map<String, dynamic>> _getFormValuesAsList() {
    return _formResponses.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polaris Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            CheckboxesWidget(
              index: 2,
              options: const [
                "OK",
                "Door Locked",
                "Bill Not available",
              ],
              isMandatory: true,
              labelText: 'Consumer Status',
              onFieldChanged: _onFieldChanged,
            ),
          ],
        ),
      ),
    );
  }
}
