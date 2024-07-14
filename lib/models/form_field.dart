import 'package:polaris_test/utils/keys_constant.dart';
import 'package:polaris_test/models/meta_info/abstract_meta_info.dart';
import 'package:polaris_test/models/meta_info/capture_image_meta_info.dart';
import 'package:polaris_test/models/meta_info/checkbox_meta_info.dart';
import 'package:polaris_test/models/meta_info/dropdown_meta_info.dart';
import 'package:polaris_test/models/meta_info/edit_text_meta_info.dart';
import 'package:polaris_test/models/meta_info/radio_group_meta_info.dart';

class FormField {
  final MetaInfo metaInfo;
  final String componentType;

  FormField({
    required this.metaInfo,
    required this.componentType,
  });

  FormField.fromJson(Map<String, dynamic> map)
      : componentType = map[keyComponentType],
        metaInfo = fromComponentType(map[keyComponentType], map[keyMetaInfo]);
}

MetaInfo fromComponentType(
    String componentType, Map<String, dynamic> metaInfoMap) {
  switch (componentType) {
    case keyEditText:
      return EditTextMetaInfo.fromJson(metaInfoMap);
    case keyCheckBoxes:
      return CheckboxMetaInfo.fromJson(metaInfoMap);
    case keyDropDown:
      return DropdownMetaInfo.fromJson(metaInfoMap);
    case keyRadioGroup:
      return RadioGroupMetaInfo.fromJson(metaInfoMap);
    case keyCaptureImages:
      return CaptureImageMetaInfo.fromJson(metaInfoMap);
    default:
      throw Exception('Unknown componentType found or component is empty!');
  }
}
