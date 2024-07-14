import 'package:polaris_test/utils/keys_constant.dart';
import 'package:polaris_test/models/meta_info/abstract_meta_info.dart';

class EditTextMetaInfo extends MetaInfo {
  final String componentInputType;

  const EditTextMetaInfo({
    required this.componentInputType,
    required super.label,
    required super.isMandatory,
  });

  EditTextMetaInfo.fromJson(Map<String, dynamic> map)
      : componentInputType = map[keyComponentInputType],
        super(
          label: map[keyLabel],
          isMandatory: map[keyMandatory] == 'yes',
        );
}
