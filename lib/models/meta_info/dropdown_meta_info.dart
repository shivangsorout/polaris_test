import 'package:polaris_test/utils/keys_constant.dart';
import 'package:polaris_test/models/meta_info/abstract_meta_info.dart';

class DropdownMetaInfo extends MetaInfo {
  final List<String> options;
  final String selectedOption;

  const DropdownMetaInfo({
    required super.label,
    required super.isMandatory,
    required this.options,
    this.selectedOption = '',
  });

  DropdownMetaInfo.fromJson(Map<String, dynamic> map)
      : options = (map[keyOptions] as List<dynamic>)
            .map<String>((item) => item)
            .toList(),
        selectedOption = map.containsKey(keyAppSelectedOption)
            ? map[keyAppSelectedOption]
            : '',
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
    if (selectedOption.isNotEmpty) {
      resultMap[keyAppSelectedOption] = selectedOption;
    }
    return resultMap;
  }
}
