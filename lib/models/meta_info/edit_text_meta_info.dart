import 'package:polaris_test/utils/keys_constant.dart';
import 'package:polaris_test/models/meta_info/abstract_meta_info.dart';

class EditTextMetaInfo extends MetaInfo {
  final String componentInputType;
  final String filledInput;

  const EditTextMetaInfo({
    required this.componentInputType,
    required super.label,
    required super.isMandatory,
    this.filledInput = '',
  });

  EditTextMetaInfo.fromJson(Map<String, dynamic> map)
      : componentInputType = map[keyComponentInputType],
        filledInput =
            map.containsKey(keyAppFilledInput) ? map[keyAppFilledInput] : '',
        super(
          label: map[keyLabel],
          isMandatory: map[keyMandatory] == 'yes',
        );

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> resultMap = {};
    resultMap[keyLabel] = label;
    resultMap[keyMandatory] = isMandatory ? 'yes' : 'no';
    resultMap[keyComponentInputType] = componentInputType;
    if (filledInput.isNotEmpty) {
      resultMap[keyAppFilledInput] = filledInput;
    }
    return resultMap;
  }
}
