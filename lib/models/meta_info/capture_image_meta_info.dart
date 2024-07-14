import 'package:polaris_test/utils/keys_constant.dart';
import 'package:polaris_test/models/meta_info/abstract_meta_info.dart';

class CaptureImageMetaInfo extends MetaInfo {
  final int numberOfImagesToCapture;
  final String savingFolder;

  const CaptureImageMetaInfo({
    required super.label,
    required super.isMandatory,
    required this.numberOfImagesToCapture,
    required this.savingFolder,
  });

  CaptureImageMetaInfo.fromJson(Map<String, dynamic> map)
      : numberOfImagesToCapture = map[keyNumberOfImages],
        savingFolder = map[keySavingFolder],
        super(
          isMandatory: map[keyMandatory] == 'yes',
          label: map[keyLabel],
        );
}
