import 'package:polaris_test/utils/keys_constant.dart';
import 'package:polaris_test/models/meta_info/abstract_meta_info.dart';

class CheckboxMetaInfo extends MetaInfo {
  final List<String> options;
  final List<String> selectedOptions;

  const CheckboxMetaInfo({
    required super.label,
    required super.isMandatory,
    required this.options,
    this.selectedOptions = const [],
  });

  CheckboxMetaInfo.fromJson(Map<String, dynamic> map)
      : options = (map[keyOptions] as List<dynamic>)
            .map<String>((item) => item)
            .toList(),
        selectedOptions = map.containsKey(keyAppSelectedOptions)
            ? map[keyAppSelectedOptions]
            : [],
        super(
          isMandatory: map[keyMandatory] == 'yes',
          label: map[keyLabel],
        );

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> resultMap = {};
    resultMap[keyLabel] = label;
    resultMap[keyMandatory] = isMandatory ? 'yes' : 'no';
    resultMap[keyOptions] = options;
    if (selectedOptions.isNotEmpty) {
      resultMap[keyAppSelectedOptions] = selectedOptions;
    }

    return resultMap;
  }
}
