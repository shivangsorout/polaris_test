import 'package:polaris_test/utils/keys_constant.dart';
import 'package:polaris_test/models/meta_info/abstract_meta_info.dart';

class DropdownMetaInfo extends MetaInfo {
  final List<String> options;

  const DropdownMetaInfo({
    required super.label,
    required super.isMandatory,
    required this.options,
  });

  DropdownMetaInfo.fromJson(Map<String, dynamic> map)
      : options = (map[keyOptions] as List<dynamic>)
            .map<String>((item) => item)
            .toList(),
        super(
          isMandatory: map[keyMandatory] == 'yes',
          label: map[keyLabel],
        );
}
