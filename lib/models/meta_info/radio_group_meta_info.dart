import 'package:polaris_test/utils/keys_constant.dart';
import 'package:polaris_test/models/meta_info/abstract_meta_info.dart';

class RadioGroupMetaInfo extends MetaInfo {
  final List<String> options;

  const RadioGroupMetaInfo({
    required this.options,
    required super.label,
    required super.isMandatory,
  });

  RadioGroupMetaInfo.fromJson(Map<String, dynamic> map)
      : options = map[keyOptions],
        super(
          isMandatory: map[keyMandatory],
          label: map[keyLabel],
        );
}
